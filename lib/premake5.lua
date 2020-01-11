newoption {
	trigger     = "name",
	value       = "unnamed",
	description = "Project name.",
}

if not _OPTIONS["name"] then error("missing name option") end

newoption {
	trigger     = "location",
	value       = "./",
	description = "Where to generate the project.",
}

if not _OPTIONS["location"] then
	_OPTIONS["location"] = "./"
end

location_dir = _OPTIONS["location"]

include(location_dir .. "conanbuildinfo.premake.lua")

project_name = _OPTIONS["name"]

function setup_pch()
	local header = project_name .. "_precompiled.h"
	pchheader(header)
	pchsource "src/precompiled.cpp"
	forceincludes{ header }
end

workspace(project_name)
	location(location_dir)
	conan_basic_setup()

	project("SFID")
		kind "StaticLib"
		language "C++"
		cppdialect "C++17"
		targetdir = location_dir .. "bin/%{cfg.buildcfg}"

		files{
			"src/**",
		}

		includedirs{
			"src",
		}

		setup_pch()

		flags{"MultiProcessorCompile"}

		defines{"_SILENCE_ALL_CXX17_DEPRECATION_WARNINGS"}

		filter "configurations:Debug"
			defines { "DEBUG" }
			symbols "On"

		filter "configurations:Release"
			defines { "NDEBUG" }
			optimize "On"

-- tests

function add_test(name)
	project("test-" .. name)
		files{
			"tests/".. name .. "/**",
			"src/precompiled.cpp"
		}

		kind "ConsoleApp"
		language "C++"
		cppdialect "C++17"
		targetdir = location_dir .. "bin/%{cfg.buildcfg}"

		includedirs{
			"src",
		}

		setup_pch()

		flags{"MultiProcessorCompile"}

		links{"SFID"}

		defines{"_SILENCE_ALL_CXX17_DEPRECATION_WARNINGS"}

		filter "configurations:Debug"
			defines { "DEBUG" }
			symbols "On"

		filter "configurations:Release"
			defines { "NDEBUG" }
			optimize "On"
end


test_dirs = os.matchdirs("./tests/*")

for k,v in pairs(test_dirs) do
	add_test( string.sub(v, string.len("tests/") + 1) )
end