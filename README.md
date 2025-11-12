#Miscellaneous Assembly Programs
A compilation of all the little scattered assembly programs I could find on my Hard Drive. I've written a lot more but I'm not always super focused on organization. Pardon.

Included Programs:

- 6502/6510 Assembly for C64:
	+ [keyboard-gen](6502/6510-c64/keyboard): A little keyboard program I wrote for the C64 in machine adjacent(hardcoded addresses and no labels, basically) assembly. I don't remember if this the one voice or three voice program, nor will I bother checking for now. Actually was part of a little d64 distribution disk image I made that also had a basic program to configure the settings for this one in zero page, among other things, but I don't know where I placed the disk image or source on that.

- x86_64/Linux:
	+ [badcat](x86/amd64/linux/badcat): A bad clone of the unix cat, with no features or options and a buffer without checking for istty(). Still it works for 99% of the cases you can use cat for.
	+ [syslinux.s](x86/amd64/misc/syslinux.s): A little include for some useful linux references.

- x86_64/Platform Agnostic:
	+ [bsprintf](x86/amd64/bsprintf): A decent _snprintf clone that does what it has to. Somehow a bug snuck in one of the later revisions, haven't gotten around to fixing it yet. Unlikely that I ever will.
