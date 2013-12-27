# Lullabyte

Lullabyte is a musical programming language and compiler written in Objective Caml. The project was developed by Stanley Chang, Louis Croce, Nathan Hayes-Roth, Andrew Langdon and Ben Nappier in 2013.

A brief tutorial has been included below. However, for full usage details, consult the Language Reference Manual in lullabyte.pdf.

### Using the Compiler

The first time using Lullabyte you must compile the project. To do this run, make:

`$ make`

To run a Lullabyte program, run the lullabyte command with your program name as a command line parameter:

`$ ./lullabyte [your_program_name.llb] [optional_midi_filename]`

The compiler generates bytecode, which is used to generate a MIDI file using the open-source Java API, JFugue.

### Sample Programs
Examples of working Lullabyte programs can be found in the Lullabyte/tests/ directory. Here's some of our favorites:

- test-jazzalg.llb
- test-heyJude.llb
- test-letItBe.llb
