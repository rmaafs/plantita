#!/bin/sh
#v4l2-ctl --set-ctrl gamma=1
#v412-ctl --set-ctrl exposure=10000
#v4l2-ctl --set-ctrl brightness=127
#fswebcam --no-banner -r 1280x1024 /home/elmaps/webcam/foto.png

#Decimos donde guardaremos la foto
path="/home/elmaps/plantita"
cd ${path}

#Horas investigando, noté que no podía hacer push desde crontab, pero descubrí que con esta línea ya me deja
#https://chai-bapat.medium.com/how-to-automate-github-using-cron-16effc825bcf
export GIT_SSH_COMMAND="ssh -i /root/.ssh/id_rsa_gh"

#Antes de cualquier cosa, bajamos los cambios
git pull

#Obtenemos el número de la foto
iter=$(cat step.txt)

locacion="${path}/fotos/foto${iter}.jpg"

#Tomamos la foto
fswebcam --no-banner -r 176x144 --jpeg 100 -S 23 ${locacion}

#Le grabamos la leyenda con la fecha actual
DATE=$(date +"%d/%m/%Y")
convert ${locacion} -font arial.ttf -pointsize 10 -fill white -annotate +0+142 $DATE ${locacion}

#Aumentamos el contador de fotos
iter=$((iter+1))
#Guardamos el contador en el archivo
echo $iter > step.txt

#Guardamos los cambios en el repositorio
git add .
git commit -m "Foto ${iter} tomada"
git push origin master

#Mandamos un aviso de que se tomó la foto
sh alert.sh "Foto ${iter} tomada" "Foto tomada correctamente"
