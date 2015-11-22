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
	@header = "Vicilog v " + @def_ver + " // Changelog / Buildtool"
	@line1  = " _    __________________    ____  ______"
	@line2  = "| |  / /  _/ ____/  _/ /   / __ \\/ ____/"
	@line3  = "| | / // // /    / // /   / / / / / __  "
	@line4  = "| |/ // // /____/ // /___/ /_/ / /_/ /  "
	@line5  = "|___/___/\\____/___/_____/\\____/\\____/   "
                                              
    puts @line1
    puts @line2
    puts @line3
    puts @line4
    puts @line5
    puts ""
    puts @header
    puts "https://github.com/dn5/vicilog"
    puts "Use argument --help for details"
    puts ""
end

def print_help
	puts "$ ruby vicilog.rb --help | usage / this menu"
	puts "$ ruby vicilog.rb --new  | new project"
	puts "                  --new    project_name"
	puts "$ ruby vicilog.rb --comp | compile / new build"
	puts "$ ruby vicilog.rb --comp   project_name"
	puts "$ ruby vicilog.rb --abt  | about the project"
	puts "$ ruby vicilog.rb --v    | version info"
	puts "$ ruby vicilog.rb --tag  | for tag list"
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

def compile_data(prjname, info)
	read_json(prjname + "/changes.json")
	rb_hash = JSON.parse(@json)
	rb_hash["overview"].unshift(info) 

	#rb_hash.to_json
	puts rb_hash
	
	@final_data = File.write(prjname + "/changes.json", rb_hash.to_json)
end

def compile_overview(prjname)
	puts "Please, enter project informations and small overview."

	@prj_overview = STDIN.gets.chomp
	compile_data(prjname, @prj_overview)
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
		puts "[+] About Vicilog [+]"
		puts "Author 	    : Coded by dn5 @ tuxbox_uni" 
		puts "Website	    : https://github.com/dn5/vicilog"
		puts "Usage 	    : Use Vicilog to make beautiful changelog / buildlogs and display them in HTML"
		puts "Inspiration : Github, actually. Template stolen from GitHub changelog :p"
		puts "Creditzz    : Ox0dea from #ruby @ freenode"
		puts "Follow me   : @dn5__ (Twitter) [+] @dn5 (GitHub)"
	when "--tag"
		puts "[+] Available tags [+]"
		puts "	new 			| for new functionality"
		puts "	fixed 			| for fixed functions or bugs"
		puts "	improved 		| for improved functions"
		puts "	removed 		| for removed functions or bugs"
		puts "	added 			| for new availability"
		puts "[+] Usage [+]"
		puts "Use the tags in brackets when adding e.g."
		puts "[fixed] Memory leak @ onLoad() function"
	when "--comp"
		if ARGV.length == 2
			write_json_from_txt(@arguments[1]) #arg1 = folder
		else
			puts "Please, set a project name or make a new one."
			puts "./vicilog.rb --comp best_project_in_teh_world"
		end
	when "--info"
		if ARGV.length == 2
			compile_overview(@arguments[1]) #arg1 = foler / project name
		else
			puts "You forgot your project. Try --info prjname."
			puts "./vicilog.rb --info best_project_in_teh_world"
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