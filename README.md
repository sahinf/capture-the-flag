# What

Bash solutions to CTF challenges (no snek)

# Why

To practice [radare2](https://github.com/radareorg/radare2) for Binex/ROP without having to rely on python abstractions
that do most of the work for us.

# Radare2 Notes

## Flags

When using `i` to get info from the opened file, such as symbols,
sections, or strings in data sections, remember to turn off color
because the output may contain invisible escape sequences that mess up
the exploit.

```bash
r2 -q \ # close after running (for scripting)
	-AA \ # analyze
	-c \ # run command (eg afl)
	-e \ # set configuration eval variable
		[scr.color=false] # Get rid of pesky invisible escape sequences
```

## Debugging

- `dc?` : continue until
- `ds?` : step 
	- `ds` : step one instruction in asm
	- `dsl` : step one source line
- `ood?` : reopen file in debug mode
