Name:           test
Version:        1.0
Release:        2%{?dist}
Summary:        Test package
License:        MIT
URL:            file:///dev/null
BuildArch:      noarch

Source0:        test-%{version}.tar

BuildRequires:  maven-local

%description
Test package

%{?javadoc_package}

%prep
%setup -q

%build
%mvn_build

%install
%mvn_install

%files -f .mfiles

%changelog
* Mon Aug 22 2022 Mikolaj Izdebski <mizdebsk@redhat.com> - 1.0-2
- Initial package
