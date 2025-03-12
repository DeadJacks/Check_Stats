::BackgroundsAttributeRanges <- {
	ID = "mod_backgrounds_attribute_ranges",
	Name = "Backgrounds and Attribute Ranges",
	Version = "1.2.0"
}
::BackgroundsAttributeRanges.HookMod <- ::Hooks.register(::BackgroundsAttributeRanges.ID, ::BackgroundsAttributeRanges.Version, ::BackgroundsAttributeRanges.Name);
::BackgroundsAttributeRanges.HookMod.queue(function()
{
	local expandTooltip = function(_tooltip)
	{
		local c = this.onChangeAttributes();
		local a = {	Hitpoints = [50, 60],
					Bravery = [30, 40],
					Stamina = [90, 100],
					MeleeSkill = [47, 57],
					RangedSkill = [32, 42],
					MeleeDefense = [0, 5],
					RangedDefense = [0, 5],
					Initiative = [100, 110]};

		foreach (att, range in a)
		{
			for (local i = 0; i < range.len(); ++i)
			{
				a[att][i] += c[att][i];
			}
		}

		local calcSpacing = function(_range)
		{
			local count = 0;
			foreach (att in _range)
			{
				count += (att == 0 ? 2 : 0) + (att < 0 ? 1 : 0);
				while (Math.abs(att) != 0)
				{
					att = Math.floor(Math.abs(att) / 10);
					count += 2;
				}
			}

			local spacing = "";
			for (local i = 0; i < 17 - count; i++)
			{
				spacing += "&nbsp;";
			}

			return spacing;
		}

		local checkExcludedTalent = function(_attribute)
		{
			return this.m.ExcludedTalents.find(_attribute) != null ? "&nbsp;[color=" + this.Const.UI.Color.NegativeValue + "]x[/color]" : "&nbsp;&nbsp;&nbsp;";
		}

		_tooltip.extend([
			{
				id = "backgrounds_attribute_ranges_0",
				type = "hint",
				text = "Диапазоны атрибутов для этого происхождения:"
			},
			{
				id = "backgrounds_attribute_ranges_1",
				type = "hint",
				text = "[img]gfx/mods/veteran_attributes/health.png[/img] " + a.Hitpoints[0] + " - " + a.Hitpoints[1] + checkExcludedTalent(this.Const.Attributes.Hitpoints) + calcSpacing(a.Hitpoints) + "[img]gfx/mods/veteran_attributes/melee_skill.png[/img] " + a.MeleeSkill[0] + " - " + a.MeleeSkill[1] + checkExcludedTalent(this.Const.Attributes.MeleeSkill)
			},
			{
				id = "backgrounds_attribute_ranges_2",
				type = "hint",
				text = "[img]gfx/mods/veteran_attributes/fatigue.png[/img] " + a.Stamina[0] + " - " + a.Stamina[1] + checkExcludedTalent(this.Const.Attributes.Fatigue) + calcSpacing(a.Stamina) + "[img]gfx/mods/veteran_attributes/ranged_skill.png[/img] " + a.RangedSkill[0] + " - " + a.RangedSkill[1] + checkExcludedTalent(this.Const.Attributes.RangedSkill)
			},
			{
				id = "backgrounds_attribute_ranges_3",
				type = "hint",
				text = "[img]gfx/mods/veteran_attributes/bravery.png[/img] " + a.Bravery[0] + " - " + a.Bravery[1] + checkExcludedTalent(this.Const.Attributes.Bravery) + calcSpacing(a.Bravery) + "[img]gfx/mods/veteran_attributes/melee_defense.png[/img] " + a.MeleeDefense[0] + " - " + a.MeleeDefense[1] + checkExcludedTalent(this.Const.Attributes.MeleeDefense)
			},
			{
				id = "backgrounds_attribute_ranges_4",
				type = "hint",
				text = "[img]gfx/mods/veteran_attributes/initiative.png[/img] " + a.Initiative[0] + " - " + a.Initiative[1] + checkExcludedTalent(this.Const.Attributes.Initiative) + calcSpacing(a.Initiative) + "[img]gfx/mods/veteran_attributes/ranged_defense.png[/img] " + a.RangedDefense[0] + " - " + a.RangedDefense[1] + checkExcludedTalent(this.Const.Attributes.RangedDefense)
			}]);

		if (this.isOffendedByViolence() || this.isCombatBackground() || this.isNoble() || this.isLowborn())
		{
			_tooltip.push(
				{
					id = "backgrounds_attribute_ranges_5",
					type = "hint",
					text = "\nКроме того, этот персонаж:"
				});

			if (this.isOffendedByViolence())
			{
				_tooltip.push(
				{
					id = "backgrounds_attribute_ranges_6",
					type = "hint",
					icon = "ui/icons/unlocked_small.png",
					text = "Обижен насилием"
				});
			}
			if (this.isCombatBackground())
			{
				_tooltip.push(
				{
					id = "backgrounds_attribute_ranges_7",
					type = "hint",
					icon = "ui/icons/unlocked_small.png",
					text = "Привык сражаться"
				});
			}
			if (this.isNoble())
			{
				_tooltip.push(
				{
					id = "backgrounds_attribute_ranges_8",
					type = "hint",
					icon = "ui/icons/unlocked_small.png",
					text = "Дворянскского происхождения"
				});
			}
			if (this.isLowborn())
			{
				_tooltip.push(
				{
					id = "backgrounds_attribute_ranges_9",
					type = "hint",
					icon = "ui/icons/unlocked_small.png",
					text = "Низкого происхождения"
				});
			}
		}

		return _tooltip;
	};

	::BackgroundsAttributeRanges.HookMod.hookTree("scripts/skills/backgrounds/character_background", function(q) // COMPANY ROSTER
	{
		q.getTooltip = @(__original) function()
		{
			return expandTooltip(__original());
		}
	});

	::BackgroundsAttributeRanges.HookMod.hook("scripts/skills/backgrounds/character_background", function(q) // TOWN SCREENS
	{
		q.getGenericTooltip = @(__original) function()
		{
			return expandTooltip(__original());
		}
	});
});
