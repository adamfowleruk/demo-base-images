# Stacks

A Stack is an application-level set of dependencies we wish to define
as an organisation to ensure all built images use the same controlled
versions of software.

These are application language specific, and may include
dependency flavours using more than one dependency management
tool for that language.

## Java Spring

The Java Spring stack provides standard library definitions for specific
versions of Java Spring.

The 'all' subfolder indicates linking to all JARs used by our organisation.
We may wish to define leaner dependency lists, E.g. for purely REST API
that are database backed. For now, we'll define an 'all' target.

Note that some dependency tools will only include the
dependencies they need from this master list. In such circumstances, 
an 'all' folder will be the only subfolder.

Subfolders also have a version number. This relates to the Stack version
number itself. main/develop branches indicate revisions to these stacks
at this version.

## Releases

A main branch 'release' tag indicates a release of our buildpack definitions.
In ordere to ensure consistent builds, link to BOTH a release tag AND
a stack version subfolder within that release, rather than just on 'main'.
