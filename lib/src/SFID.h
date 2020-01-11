#pragma once

struct Command
{
	std::string str;
	// return exit value
	int run();
};

namespace deco
{
	template<typename Stream> constexpr
	void serialize(Stream& stream, Command& value)
	{
		deco::serialize(stream, value.str);
	}
}


struct Project
{
	std::string repository;
	std::string branch;
	std::vector<Command> commands;

	void setup() const;
};

namespace deco
{
	template<typename Stream> constexpr
		void serialize(Stream& stream, Project& value)
	{
		serialize(stream, value.repository);
		serialize(stream, value.branch);
		serialize(stream, deco::make_list("commands", value.commands));
	}
}


struct SFID
{
	std::vector<Project> projects;

	void load_config(std::filesystem::path const& filepath);
};