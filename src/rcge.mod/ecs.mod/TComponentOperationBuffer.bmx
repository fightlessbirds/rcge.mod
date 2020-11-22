Private

Type TComponentOperationBuffer
	
	Const OP_BIND:Int = 1
	Const OP_UNBIND:Int = 2
	
	Method New(ecs:TEcs)
		_ecs = ecs
	EndMethod
	
	Method enqueueBind(relationship:TIntMap, e:TEntity, cType:TTypeId, c:Object)
		Local op:TComponentOperation = New TComponentOperation(OP_BIND, relationship, e, cType, c)
		_componentOperations.addLast(op)
	EndMethod
	
	Method enqueueUnbind(relationship:TIntMap, e:TEntity, cType:TTypeId)
		Local op:TComponentOperation = New TComponentOperation(OP_UNBIND, relationship, e, cType, Null)
		_componentOperations.addLast(op)
	EndMethod
	
	Method flush()
		Repeat
			Local o:Object = _componentOperations.removeFirst()
			If o = Null Then Exit
			Local operation:TComponentOperation = TComponentOperation(o)
			Local e:TEntity = operation.e
			Select operation.op
				Case OP_BIND
					e._components.insert(operation.cType, operation.c)
					operation.relationship.insert(e.getId(), e)
				Case OP_UNBIND
					e._components.remove(operation.cType)
					operation.relationship.remove(e.getId())
			EndSelect
		Forever
	EndMethod
	
	
	Private
	
	Field _ecs:TEcs
	
	Field _componentOperations:Tlist = New Tlist()
	
EndType

Type TComponentOperation
	
	Field op:Int
	Field relationship:TIntMap
	Field e:TEntity
	Field cType:TTypeId
	Field c:Object
	
	Method New(op:Int, relationship:TIntMap, e:TEntity, cType:TTypeId, c:Object)
		Self.op = op
		Self.relationship = relationship
		Self.e = e
		Self.cType = cType
		Self.c = c
	EndMethod
	
EndType

Public
