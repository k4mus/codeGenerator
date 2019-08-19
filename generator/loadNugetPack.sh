rm -rf NUCLEO
mkdir NUCLEO
java -jar target/CodeGenerator-0.0.1.jar ftl nuget.ftl ftl/projects.json yml 
cd NUCLEO
input="output.txt"
cat $input
while IFS="," read -r f1 f2 f3
do
if [[ $f1 != --* && $f1 != ""  ]]; then
pwd
echo "repo a traer" $f2;
cd $f1
git clone --single-branch --branch develop $f2 
cd $f1
pwd
ls -al
packs_path=$(grep -E -o [aA-zZ.:0-9]*.csproj .gitlab-ci.yml |sort|uniq|sed 's/\\/\//g' | xargs echo | sed 's/ /\",\"/g') 
echo "packs_path="$packs_path
cat ../Jenkinsfile | sed -e "s+#PACKS_PATH+$packs_path+g">Jenkinsfile 
git add Jenkinsfile
git commit -m "se actualiza jenkins file"
#git push origin develop

cd ../..

fi;
done < "$input"; 