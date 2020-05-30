SuperStrict

Module rcge.pool

ModuleInfo "Version: 1.0.0"
ModuleInfo "Author: fightlessbirds"
ModuleInfo "License: MIT"
ModuleInfo "Copyright: 2020 fightlessbirds, 2011 Nathan Sweet"

ModuleInfo "History: 1.0.0"
ModuleInfo "History: Initial Release"

Import BRL.Collections

Rem
bbdoc: A pool of objects that can be reused to avoid allocation.
about: Partly translated from https://github.com/libgdx/libgdx/blob/master/gdx/src/com/badlogic/gdx/utils/Pool.java
EndRem
Type TPool<T> Abstract
	
	Rem
	bbdoc: TPool constructor
	about: @initialSize is the initial size of the pool.
	@max is the maximum number of free objects to store in this pool.
	EndRem
	Method New()(initialSize:Int = 0, maxSize:Int=INT_MAX_VALUE)
		If initialSize > maxSize
			Throw("TPool.New(): max must be larger than initialCapacity")
		EndIf
		_freeObjects = New TStack<IPoolable>()
		_maxSize = maxSize
		For Local i:Int = 0 To initialSize
			_freeObjects.push(newObject())
		Next
	EndMethod
	
	Rem
	bbdoc: The maximum number of objects that will be pooled.
	EndRem
	Method getMax:Int()
		Return _maxSize
	EndMethod
	
	Rem
	bbdoc: Returns an object from this pool.
	about: The object may be new from newObject() or reused from previous free().
	EndRem
	Method obtain:T()
		If _freeObjects.count() = 0
			Return newObject()
		EndIf
		Return _freeObjects.pop()
	EndMethod
	
	Rem
	bbdoc: Puts the specified object in the pool, making it eligible to be returned by obtain().
	about: If the pool already contains max free objects, the specified object is reset but not added to the pool.
	The pool does not check if an object is already freed, so the same object must not be freed multiple times.
	EndRem
	Method free(obj:T)
		If obj = Null
			Throw("TPool.free(): object cannot be Null")
		EndIf
		If _freeObjects.count() < _maxSize
			_freeObjects.push(obj)
		EndIf
		reset(obj)
	EndMethod
	
	Rem
	bbdoc: Adds the specified number of new free objects to the pool.
	about: Usually called early on as a pre-allocation mechanism but can be used at any time.
	EndRem
	Method fill(size:Int)
		For Local i:Int = 0 To size
			If _freeObjects.count() < _maxSize
				_freeObjects.push(newObject())
			EndIf
		Next
	EndMethod
	
	Rem
	bbdoc: Puts the specified objects in the pool.
	about: Null objects within the array are silently ignored. The pool does not check if
	an object is already freed, so the same object must not be freed multiple times.
	EndRem
	Method freeAll(objects:T[])
		If obj = Null
			Throw("TPool.freeAll(): objects cannot be Null")
		EndIf
		For Local obj:T = EachIn objects
			If obj = Null Then Continue
			If _freeObjects.count() < _maxSize Then _freeObjects.push(obj)
			reset(obj)
		Next
	EndMethod
	
	Rem
	bbdoc: Removes all free objects from this pool.
	EndRem
	Method clear()
		_freeObjects.clear()
	EndMethod
	
	Rem
	bbdoc: The number of objects available to be obtained.
	EndRem
	Method getFree:Int()
		Return _freeObjects.count()
	EndMethod
	
	
	Protected
	
	Rem
	bbdoc: Override this to return a new object for this pool.
	about: The object must implement the IPoolable interface.
	EndRem
	Method newObject:T() Abstract
	
	Rem
	bbdoc: Called when an object is freed to clear the state of the object for possible later reuse.
	about: Calls Poolable.reset() if the object implements IPoolable.
	EndRem
	Method reset(obj:T)
		If TTypeId.ForObject(obj).extendsType(TTypeId.ForName("IPoolable"))
			IPoolable(obj).reset()
		EndIf
	EndMethod
	
	
	Private
	
	Field _maxSize:Int
	
	Field _freeObjects:TStack<T>
	
	'Private default constructor
	Method New()
	EndMethod
	
EndType

Rem
bbdoc: Objects implementing this interface will have reset() called when passed to Pool.free().
EndRem
Interface IPoolable
	Rem
	bbdoc: Resets the object for reuse.
	about: Object references should be nulled and fields may be set to default values.
	EndRem
	Method reset()
EndInterface

Private

Const INT_MAX_VALUE:Int = 2147483647
