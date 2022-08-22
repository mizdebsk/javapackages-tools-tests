#!/bin/sh -eux

tmp=$(mktemp -d)
mkdir $tmp/SOURCES $tmp/pkg $tmp/javadoc $tmp/jar

tar -c -v -f $tmp/SOURCES/test-1.0.tar test-1.0

rpmbuild -D "_topdir $tmp" -ba test.spec

dist=$(rpm -E '%{?dist}')
nvr=test-1.0-2$dist
srpm=$tmp/SRPMS/$nvr.src.rpm
rpm=$tmp/RPMS/noarch/$nvr.noarch.rpm
javadoc=$tmp/RPMS/noarch/${nvr/test/test-javadoc}.noarch.rpm

rpm -qip $srpm
rpm -qip $rpm
rpm -qip $javadoc

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
