# -
# Vicilog (Built by Vicidex) | rel 0.1 aka 100
# -
# Author 	:	dn5
# Twitter 	:	@dn5__
# Blog 		:	http://dn5.ljuska.org
# -

#!/usr/bin/env ruby


require 'json'
require 'fileutils'

# CONSTANTS
@def_dir 	= "default"					# Default directory
@def_rel 	= "rel.js"					# Default release system API
@def_ind 	= "index.html"				# Default index page
@def_minOS 	= "Linux Ubuntu 14.04"

@def_ver    = "100"
@def_build  = "14. Nov 2015."

def print_header
	puts <<EOL
_    __________________    ____  ______
| |  / /  _/ ____/  _/ /   / __ \\/ ____/
| | / // // /    / // /   / / / / / __  
| |/ // // /____/ // /___/ /_/ / /_/ /  
|___/___/\\____/___/_____/\\____/\\____/

Vicilog v #{@def_ver} // Changelog / Buildtool
https://github.com/dn5/vicilog
Use argument --help for details
EOL

end

def print_help
	puts <<EOL
$ ruby vicilog.rb --help | usage / this menu
$ ruby vicilog.rb --new  | new project
                  --new    project_name
$ ruby vicilog.rb --comp | compile / new build
$ ruby vicilog.rb --comp   project_name
$ ruby vicilog.rb --abt  | about the project
$ ruby vicilog.rb --v    | version info
$ ruby vicilog.rb --tag  | for tag list
EOL
end

# Read JSON file
# file - filename
def read_json(file)
	@json = File.read(file)
end

def write_data_to_json(key, value)
	(@final ||= "") << "• " + value + "\r\n"

	puts @final
end

def append_data(prjname)
	read_json(prjname + "/changes.json")
	rb_hash = JSON.parse(@json)
	rb_hash["releases"].unshift(@cl_hash) 

	#rb_hash.to_json
	puts rb_hash
	
	@final_data = File.write(prjname + "/changes.json", rb_hash.to_json)
end

def compile_project_by_name(prjname)
	@cl_hash = {
		"title"       => @cl_title,
		"description" => @final,
		"date" 		  => @cl_dtime,
		"version" 	  => @cl_version,
		"url" 		  => @cl_package,
		"size" 		  => @cl_md5,
		"minimum_os"  => @def_minOS,
		"lulz" 		  => @cl_lulz
	}

	puts @cl_hash.to_json
	append_data(prjname)
end

def write_json_from_txt(prjname)
	
	if File.directory? prjname
		puts "Please enter the build/changelog title:"
		@cl_title = STDIN.gets.chomp

		puts "Please enter date or leave empty for auto-adjust:"
		@cl_dtime = STDIN.gets.chomp
		if @cl_dtime == ""
			time_now = Time.now.strftime("%a, %d %b %Y %H:%M:%S")
			@cl_dtime = time_now 

			puts @cl_dtime
		end

		puts "Please enter build version:"
		@cl_version = STDIN.gets.chomp

		puts "Package name (Optional):"
		@cl_package = STDIN.gets.chomp

		puts "Package checksum (Optional):"
		@cl_md5 = STDIN.gets.chomp

		puts "Lulz (Optional):"
		@cl_lulz = STDIN.gets.chomp

		puts "Insert your changelog data (Hint: use a tags; e.g. [improved]):"
		while @changelog_data = STDIN.gets.chomp
			case @changelog_data
			when "end"
				puts "Excelent! Compile your project."
				compile_project_by_name(prjname)
				break
			else
				puts "Insert your changelog data (Hint: use a tags; e.g. [improved]):"
				write_data_to_json("description", @changelog_data)
			end
		end
	end
	#@changelog = STDIN.gets.chomp
end

# Make new project
# str - projectname
def new_project(str)
	puts "Vicilog is currently creating new project ..."

	FileUtils::mkdir_p str

	# Make a new copy
	puts "Copying necessery files ..."
	FileUtils.cp(@def_dir + "/" + @def_rel,  str)	# Page name
	FileUtils.cp(@def_dir + "/" + @def_ind,  str)	# Back-end vanilla JS API
	FileUtils.cp(@def_dir + "/changes.json", str)        # Don't edit, could brick the vicilog

	puts "New project sucesfully built! Run --comp project_name to compile new changes!"
end

print_header

@arguments = ARGV

	case @arguments[0]
	when "--help"
		print_help
	when "--v"
		puts "Current version : " + @def_ver
		puts "Build date      : " + @def_build
	when "--new"
		if ARGV.length == 2
			new_project(@arguments[1])
		else 
			puts "Please, give a name to your project! :)"
			puts "./vicilog.rb --new best_project_in_teh_world"
		end
	when "--abt"
		puts <<EOL
[+] About Vicilog [+]
Author 	    : Coded by dn5 @ tuxbox_uni 
Website	    : https://github.com/dn5/vicilog
Usage 	    : Use Vicilog to make beautiful changelog / buildlogs and display them in HTML
Inspiration : Github, actually. Template stolen from GitHub changelog :p
Creditzz    : Ox0dea from #ruby @ freenode
Follow me   : @dn5__ (Twitter) [+] @dn5 (GitHub)
EOL
	when "--tag"
		puts <<EOL
[+] Available tags [+]
	new 			| for new functionality
	fixed 			| for fixed functions or bugs
	improved 		| for improved functions
	removed 		| for removed functions or bugs
	added 			| for new availability
[+] Usage [+]
Use the tags in brackets when adding e.g.
[fixed] Memory leak @ onLoad() function
EOL
	when "--comp"
		if ARGV.length == 2
			write_json_from_txt(@arguments[1]) #arg1 = folder
		else
			puts "Please, set a project name or make a new one."
			puts "./vicilog.rb --comp best_project_in_teh_world"
		end
	else
		puts "Good to go!"
	end
		

#print_help
#append_data()
#write_json_from_txt(ARGV[0])
#new_project("vicilog")
#read_json("changes.json")
#puts JSON.parse(@json)
