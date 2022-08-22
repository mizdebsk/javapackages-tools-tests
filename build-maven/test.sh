#!/bin/sh -eux

tmp=$(mktemp -d)
mkdir $tmp/pkg $tmp/javadoc $tmp/jar

rpmbuild -D "_sourcedir $PWD" -D "_topdir $tmp" -ba test.spec

nvr=test-1.0-2.fc35
srpm=$tmp/SRPMS/$nvr.src.rpm
rpm=$tmp/RPMS/noarch/$nvr.noarch.rpm
javadoc=$tmp/RPMS/noarch/${nvr/test/test-javadoc}.noarch.rpm

rpm -qip $srpm
rpm -qip $rpm
rpm -qip $javadoc
test -d $tmp/BUILD/test-1.0/target/classes

rpm2archive -n $rpm
tar -C $tmp/pkg -x -v -f $rpm.tar
rpm2archive -n $javadoc
tar -C $tmp/javadoc -x -v -f $javadoc.tar

test -f $tmp/pkg/usr/share/java/test/test-aid.jar
test -f $tmp/pkg/usr/share/maven-poms/test/test-aid.pom
test -f $tmp/pkg/usr/share/maven-metadata/test.xml
test -f $tmp/javadoc/usr/share/javadoc/test/index.html

unzip -d $tmp/jar $tmp/pkg/usr/share/java/test/test-aid.jar
test -f $tmp/jar/test/Test.class
test -f $tmp/jar/META-INF/MANIFEST.MF
test -f $tmp/jar/META-INF/maven/test-gid/test-aid/pom.xml
test -f $tmp/jar/META-INF/maven/test-gid/test-aid/pom.properties

rm -rf $tmp
