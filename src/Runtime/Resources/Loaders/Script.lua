return {
    Load = function(ScriptBytes, Identifier)
        return Runtime.ScriptUtil.PreProcess(ScriptBytes, Identifier.ID)
    end,
	Unload = function(Resource)
		print("TODO: Unload scripts")
	end
}