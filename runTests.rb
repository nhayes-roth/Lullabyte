#!/usr/bin/env ruby

# remove junk
`rm interpret > /dev/null 2>&1`
`rm *.cmo > /dev/null 2>&1`
`rm *.cmi > /dev/null 2>&1`
`ocamllex scanner.mll `
`ocamlyacc parser.mly `
`ocamlc -c ast.ml `
`ocamlc -c parser.mli `
`ocamlc -c scanner.ml `
`ocamlc -c parser.ml`
`ocamlc -c interpreter.ml`
`ocamlc -o interpret ast.cmo parser.cmo scanner.cmo interpreter.cmo`

#
# For each .out file in the tests directory,
# find the corresponding .llb file,
# run it,
# and compare the .out file to the actual output
#
Dir['tests/*.out'].each do |filePath|
	expected_output = File.read(filePath)
	test_file = filePath.gsub('.out', '.llb')
	actual_output = `./interpret < #{test_file}`
	test_name = test_file.gsub('tests/', '')
						 .gsub('.llb', '') 

	if expected_output == actual_output
		puts "\e[32m" + test_name + " passed!"
	else 
		puts "\n\n\e[31m" + test_name + " failed. It could be a whitespace issue!"
		puts "\e[37m---Expected_output: \n" + expected_output
		puts "\e[31m---Actual output: \n" + actual_output
	end
end

puts "\e[0m"




