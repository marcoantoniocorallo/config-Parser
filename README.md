# Config-Parser

---

A simple parser that reads a configuration file and stores the information in a data structure.

A configuration file is composed by *sections*, that contain bindings between *variables* and *values*. Sections and variables are identified by alphanumeric strings.

Values can be *integers*, *booleans*, *strings* or *reference* to other variables, specified by the character `$`. If the specified variable belongs to another section, this must be specified using the *dot-notation*: `$namesection.namevar`.

At the beginning of the file there can be directives to *import* configurations from other external files.

An example of a valid configuration file is the following.

```
#import<external.config>
#import<another_external.config>
sect1{
    var1 = "hi!";
    // this is a comment!
    var2 = true;
    var3 = 42;
}
sect2{
    goofy = $sect1.var2;
} 
```
In case of **duplicate identifiers** (sections or variables of the same section), **an error will be raised**.

The data structure built is a map `[section, [var, value] ]`; the implementation defined in the module DataStructure provides also a method for removing a section and one for removing a single binding.

It also provides a *pretty-printer* that prints the structure in the format of configuration files, so it can be used for *serializing* the structure.

---
###### Note: the import directive has been treated in the lexer for simplicity, in the parser it caused circular-dependencies errors.
