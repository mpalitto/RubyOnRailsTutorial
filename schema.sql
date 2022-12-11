# rails generate model Task title:string note:text completed:date
rails='rails generate model'
tables=$(sed -n '/create_table/{s/.* "//;s/s".*//p}' db/schema.rb)
for table in $tables; do 
  echo $rails $(echo $table | sed 's/\(.\)/\u\1/') $(sed -n '/'$table'/,/end/{/tasks/!{/end/!{s/.*t\.\(.*\) "\(.*\)".*/\2:\1/p}}}' db/schema.rb)
done