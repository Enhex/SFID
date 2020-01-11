#include "SFID.h"

namespace bp = boost::process;
using namespace std::string_literals;

int Command::run()
{
	return bp::system(str, bp::std_out > "log.txt");
}

void Project::setup() const
{
	//TODO navigate to project build dir

	auto const str = "git clone --depth=1 -b="s += branch + " "s += repository + " ./src";
	bp::system(str, bp::std_out > "log.txt");
}

void SFID::load_config(std::filesystem::path const& filepath)
{
}