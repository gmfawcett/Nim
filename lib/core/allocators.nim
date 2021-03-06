#
#
#            Nim's Runtime Library
#        (c) Copyright 2017 Nim contributors
#
#    See the file "copying.txt", included in this
#    distribution, for details about the copyright.
#

type
  AllocatorFlag* {.pure.} = enum  ## flags describing the properties of the allocator
    ThreadLocal ## the allocator is thread local only.
    ZerosMem    ## the allocator always zeros the memory on an allocation
  Allocator* = ptr object {.inheritable.}
    alloc*: proc (a: Allocator; size: int; alignment: int = 8): pointer {.nimcall.}
    dealloc*: proc (a: Allocator; p: pointer; size: int) {.nimcall.}
    realloc*: proc (a: Allocator; p: pointer; oldSize, newSize: int): pointer {.nimcall.}
    deallocAll*: proc (a: Allocator) {.nimcall.}
    flags*: set[AllocatorFlag]

var
  localAllocator {.threadvar.}: Allocator
  sharedAllocator: Allocator

proc getLocalAllocator*(): Allocator =
  result = localAllocator

proc setLocalAllocator*(a: Allocator) =
  localAllocator = a

proc getSharedAllocator*(): Allocator =
  result = sharedAllocator

proc setSharedAllocator*(a: Allocator) =
  sharedAllocator = a

when false:
  proc alloc*(size: int; alignment: int = 8): pointer =
    let a = getCurrentAllocator()
    result = a.alloc(a, size, alignment)

  proc dealloc*(p: pointer; size: int) =
    let a = getCurrentAllocator()
    a.dealloc(a, p, size)

  proc realloc*(p: pointer; oldSize, newSize: int): pointer =
    let a = getCurrentAllocator()
    result = a.realloc(a, p, oldSize, newSize)
