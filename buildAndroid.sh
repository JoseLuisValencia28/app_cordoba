# echo “Limpiando build Atlantico”
# flutter clean

# echo Compilado apk Atlantico”
# #flutter build apk --release --no-sound-null-safety

# echo Compilado bundle Atlantico”
# #flutter build appbundle --build-name=1.0.16 --build-number=17 --no-sound-null-safety

# echo Compilado bundle Atlantico”

# flutter build ipa --no-sound-null-safety

# RUTA_OPEN=/Users/ecarbono/Documents/Proyectos/flutter_application_cordoba/build/ios/

# echo Abriendo Ruta del ipa”
# open RUTA_OPEN

# RUTA=/Users/ecarbono/Documents/Proyectos/apk/huila/android

# FILE=$RUTA/app-release.apk
# FILE_BUNDLE=$RUTA/app-release.aab

# if [ -f "$FILE" ] && [-f "$FILE_BUNDLE"]; then
#     echo “Limpiando apk Git Huila
#     rm $FILE
#     echo “Limpiando bundle Git Huila
#     rm $FILE_BUNDLE
#     cd ../apk
#     git stage .
#     git commit -m "Delete apk Commit"
#     git push origin master
# fi

# FILE_APP_PROYECT=/Users/ecarbono/Documents/Proyectos/flutter_application_huila/build/app/outputs/apk/release/app-release.apk
# FILE_APP_GIT=/Users/ecarbono/Documents/Proyectos/apk/huila/android/

# echo “Copiando apk a git Huila”
# cp -R $FILE_APP_PROYECT $FILE_APP_GIT

# cd ../apk
# git stage .
# git commit -m "Commit new App"
# git push origin master
