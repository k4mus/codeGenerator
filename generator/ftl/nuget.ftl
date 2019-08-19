#!groovy
packs_path = ["#PACKS_PATH"]

def props
pipeline {
  agent {label 'win'}
  parameters {
        string(name: 'JIRA_ISSUE', defaultValue: '', description: 'Ticket de Jira asociado')
      
  }
  triggers {
        gitlab(triggerOnPush: true, triggerOnMergeRequest: true, branchFilterType:'NameBasedFilter',includeBranchesSpec: "feature/*",excludeBranchesSpec: "")
    }
  environment {
    project="${name?replace("Alemana.Nucleo.", "")}"
    prefix="Alemana.Nucleo"
    PROP_CONFIG='b9607638-77ad-421d-acc7-71a89c404b4f'
  }
  <#noparse>
  stages {
    stage('checkout') {
        when {
            beforeAgent true
            anyOf {
                allOf { 
                    anyOf {
                        branch 'master';
                        branch 'develop';
                    }
                };
                branch 'feature/*';
                branch 'hotfix/*';
                branch 'datafix/*';
                branch 'release/*';
              }
        }
      steps {
        checkout scm
        echo 'Pulling...'+env.GIT_BRANCH
        script{
            configFileProvider(
                [configFile(fileId: "${PROP_CONFIG}", variable: 'configFile')]) {
                props = readProperties file: "$configFile"
            }
        }
        
      }
    }
    stage('validar') {
        when {
            beforeAgent true
            not {
                anyOf {
                    allOf { 
                        not { environment name: 'JIRA_ISSUE', value: '' };
                        anyOf {
                            branch 'master';
                            branch 'develop';
                            branch 'release/*';
                            branch 'datafix/*';
                            branch 'hotfix/*';
                        }
                    };
                    branch 'feature/*';
              }
            }
        }
      steps {
        script{
            currentBuild.result = 'ABORTED'
        }
        
        error "Pipeline no se puede ejecutar pues requiere el ticket de Jira o bien no es una rama feature";
      }
    }  
    stage('Deploy Sql Desarrollo') {
      when {
                branch 'feature/*'
            }
      steps {
        script{
           sonar(props['NUGET_PACKAGE_SOURCE_INT'],"${prefix}.${project}")
            compile(props['NUGET_PACKAGE_SOURCE_INT'], "${prefix}.${project}")
            withCredentials([string(credentialsId: 'nucleo-nuget', variable: 'conexion')]) {
                bat "nuget.exe push ${prefix}.${project}.*.nupkg ${conexion} -Source "+props['NUGET_PACKAGE_TARGET_INT']
            }
          }
      }
    }
    stage('Deploy Sql Certificacion') {
      when {
           allOf { 
            not { environment name: 'JIRA_ISSUE', value: '' };
            branch 'develop' 
            }
        }
      steps {
          script{
       
            sonar(props['NUGET_PACKAGE_SOURCE_QA'],"${prefix}.${project}")
            compile(props['NUGET_PACKAGE_SOURCE_QA'], "${prefix}.${project}")
            withCredentials([string(credentialsId: 'nucleo-nuget', variable: 'conexion')]) {
                bat "nuget.exe push ${prefix}.${project}.*.nupkg ${conexion} -Source "+props['NUGET_PACKAGE_TARGET_QA']
            }
          }
      }
    }
    stage('Deploy Sql Pre-Produccion') {
      when {
           allOf { 
            not { environment name: 'JIRA_ISSUE', value: '' };
            branch 'release/*' 
            }
        }
      steps {
        script{
          sonar(props['NUGET_PACKAGE_SOURCE_PREPROD'],"${prefix}.${project}")
          compile(props['NUGET_PACKAGE_SOURCE_PREPROD'], "${prefix}.${project}")
          withCredentials([string(credentialsId: 'nucleo-nuget', variable: 'conexion')]) {
              bat "nuget.exe push ${prefix}.${project}.*.nupkg ${conexion} -Source "+props['NUGET_PACKAGE_TARGET_PREPROD']
          }
        }
      }
    }
    stage('Deploy Sql Produccion') {
      when {
            allOf { 
                not { environment name: 'JIRA_ISSUE', value: '' };
                anyOf {
                    branch 'master';
                    branch 'datafix/*';
                }; 
            }
        }
      steps {
        script{
          sonar(props['NUGET_PACKAGE_SOURCE_PROD'],"${prefix}.${project}")
          compile(props['NUGET_PACKAGE_SOURCE_PROD'], "${prefix}.${project}")
          withCredentials([string(credentialsId: 'nucleo-nuget', variable: 'conexion')]) {
              bat "nuget.exe push ${prefix}.${project}.*.nupkg ${conexion} -Source "+props['NUGET_PACKAGE_TARGET_PROD']
          }
        }
      }
    }
  }
  post {
        always { 
            echo 'Limpiando espacio de trabajo.'
            cleanWs()
        }
        success {
            echo 'Finalizado con exito'
            //office365ConnectorSend message: 'success - Finalizado con exito', status: 'success', webhookUrl: props['WEBHOOK_OFFICE365']
        }
        unstable {
            echo 'Algun paso del pipeline ha fallado.'
            //office365ConnectorSend message: 'unstable - Algun paso del pipeline ha fallado', status: 'unstable', webhookUrl: props['WEBHOOK_OFFICE365']
        }
        failure {
            echo 'El pipeline ha fallado.'
            //office365ConnectorSend message: 'failure - El pipeline ha fallado.', status: 'failure', webhookUrl: props['WEBHOOK_OFFICE365']
        }
        aborted {
            echo 'Algo ha cambiado en el repositorio.'
            //office365ConnectorSend message: 'aborted - Algo ha cambiado en el repositorio.', status: 'aborted', webhookUrl: props['WEBHOOK_OFFICE365']
        }
    }
}

//Funciones utilitarias
def sonar(source, proj) {
    
    print "Revisando con sonar..."    
    def scannerHome = tool 'SonarMs';
    withSonarQubeEnv('sonarqube') {
      
      bat "${scannerHome}\\SonarScanner.MSBuild.exe begin /k:${proj}:"+env.GIT_BRANCH.replace("/", "-")
      bat "nuget.exe restore -Source ${source} ${proj}.sln"
      bat "nuget.exe update ${proj}.sln -Source ${source} -FileConflictAction overwrite"
      bat "MSBuild.exe ${proj}.sln"+' /t:Clean,ReBuild /p:Configuration=Release;Platform="Any CPU"'
      bat "${scannerHome}\\SonarScanner.MSBuild.exe end"
      
    }
    sleep(time:10,unit:"SECONDS")
    timeout(time: 1, unit: 'MINUTES') {
        def qgate = waitForQualityGate()
        if (qgate.status != 'OK') {
          error "Pipeline aborted due to quality gate failure: ${qgate.status}"
        }
    }
}
    
def compile(source, proj) {
  print "compilando"
  bat "nuget.exe restore -Source ${source} ${proj}.sln"
  bat "nuget.exe update ${proj}.sln -Source ${source} -FileConflictAction overwrite"
  bat "MSBuild.exe ${proj}.sln /t:Clean,ReBuild /p:Configuration=Release;"+'Platform="Any CPU"'
  loop_of_pack(packs_path)
  sleep(time:10,unit:"SECONDS")
}

def loop_of_pack(list) {
  print "empaquetando"
  list.each { item ->
      bat "nuget.exe pack ${item} -Properties Configuration=Release"
  }
}
</#noparse>