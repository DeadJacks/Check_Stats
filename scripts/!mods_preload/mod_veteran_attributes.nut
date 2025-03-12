::VeteranAttributes <- {
	ID = "mod_veteran_attributes",
	Name = "Veteran Attributes 11",
	Version = "1.2.0"
}
::VeteranAttributes.HookMod <- ::Hooks.register(::VeteranAttributes.ID, ::VeteranAttributes.Version, ::VeteranAttributes.Name);
::VeteranAttributes.HookMod.queue(function()
{
	::VeteranAttributes.HookMod.hook("scripts/entity/tactical/player", function(q)
	{
		q.onInit = @(__original) function()
		{
			__original();
			if (this.m.IsControlledByPlayer && !this.getSkills().hasSkill("special.veteran_attributes_info"))
				this.getSkills().add(this.new("scripts/skills/special/veteran_attributes_info"));
		}
	});
});
