#!/bin/bash
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