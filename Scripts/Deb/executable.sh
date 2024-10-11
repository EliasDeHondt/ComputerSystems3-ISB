#!/bin/bash
############################
# @author Elias De Hondt   #
# @see https://eliasdh.com #
# @since 11/10/2024        #
############################

package="pakket"
version="1"
mkdir -p "${package}/${package}-${version}"
cd "${package}/${package}-${version}"
cat > ${package} <<EOF
#!/bin/sh
zenity --warning --text="\`exec uname -a\`"
EOF
chmod 755 $package
cd ..
tar -cvzf ${package}-${version}.tar.gz ${package}-${version}