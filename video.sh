#Generar un gif con todas las fotos
ffmpeg -r 10 -f image2 -i ./fotos/foto%d.jpg ./final3.gif
