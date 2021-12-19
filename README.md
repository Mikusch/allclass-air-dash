# [TF2] All-Class Air Dash

This is a simple SourceMod plugin for Team Fortress 2 that enables all classes to perform air dashes, also referred to as double jumps.

This implementation patches the class check in `CTFPlayer::CanAirDash`, which means it respects all convars, attributes and conditions related to air dashing.

## Dependencies

* SourceMod 1.10+
* [MemoryPatch](https://github.com/Kenzzer/MemoryPatch) (compile only)

## Configuration

* `tf_allclass_air_dash ( def. "1" )` - When set to 1, enables all classes to perform air dashes
