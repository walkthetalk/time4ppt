import qbs

Project {
	minimumQbsVersion: "1.7.1"

	CppApplication {
		// workaround: if using clang on windows, we must assign them explicity
		//             please see: https://bugreports.qt.io/browse/QBS-1322
		// x86_64-w64-windows-gnu
		cpp.targetVendor: "w64"
		cpp.targetSystem: "windows"
		cpp.targetAbi: "gnu"
		// workaround: if using clang on windows x64, we must disable it.
		cpp.positionIndependentCode: false

		Depends {
			name: "Qt";
			submodules: [
				"core",
				"quick"
			]
		}

		// NOTE 1: the platform plugin must be explicity included when
		//         use static qt library.
		Depends {
			name: "Qt.qwindows";
			condition: Qt.core.staticBuild && qbs.targetOS.contains("windows")
		}

		// Additional import path used to resolve QML modules in Qt Creator's code model
		property pathList qmlImportPaths: []

		// GUI application
		consoleApplication: false

		cpp.treatWarningsAsErrors: true
		cpp.cxxLanguageVersion: "c++11"

		cpp.driverLinkerFlags: {
			var ret = []
			// strip output when in release mode
			if (qbs.buildVariant === "release")
				ret.push("-s")
				/// alt: ret = ret.concat(["-s"])
			if (cpp.compilerHasTargetOption)
				ret.push("-hehehe")
			// NOTE 2: when use static qt library on windows, must link
			//         static gcc/stdc++ library for removing corresponding
			//         dependency when running.
			if (qbs.targetOS.contains("windows")) {
				if (Qt.core.staticBuild) {
					if (qbs.toolchain.contains("mingw")) {
						ret.push("-static-libgcc")
						ret.push("-static-libstdc++")
						ret.push("-static")
					}
				}
			}
			return ret
		}

		cpp.dynamicLibraries: {
			var ret = []
			// NOTE 3: when use static qt library on windows, we must tell
			//         it using dynmaic ws2_32.dll explicitly.
			if (qbs.targetOS.contains("windows")) {
				if (Qt.core.staticBuild) {
					ret.concat("ws2_32")
				}
			}
			return ret
		}

		cpp.defines: [
			// The following define makes your compiler emit warnings if you use
			// any feature of Qt which as been marked deprecated (the exact warnings
			// depend on your compiler). Please consult the documentation of the
			// deprecated API in order to know how to port your code away from it.
			"QT_DEPRECATED_WARNINGS",

			// You can also make your code fail to compile if you use deprecated APIs.
			// In order to do so, uncomment the following line.
			// You can also select to disable deprecated APIs only up to a certain version of Qt.
			"QT_DISABLE_DEPRECATED_BEFORE=0x060000" // disables all the APIs deprecated before Qt 6.0.0
		]

		// for integrating quick plugin correctly, we must add main.qml
		// to files, but not only to qml.qrc
		files: [
			"main.cpp",
			"main.qml",
			"qml.qrc",
		]

		Group {     // Properties for the produced executable
			fileTagsFilter: "application"
			qbs.install: true
		}
	}
}
