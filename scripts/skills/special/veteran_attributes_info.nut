this.veteran_attributes_info <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "special.veteran_attributes_info";
		this.m.Name = "Характеристики ветерана";
		this.m.Description = "";
		this.m.Icon = "mods/veteran_attributes/icon.png";
		this.m.IconMini = "";
		this.m.Type = this.Const.SkillType.Special | this.Const.SkillType.Trait;
		this.m.Order = this.Const.SkillOrder.Background + 600;
		this.m.IsActive = false;
		this.m.IsHidden = true;
		this.m.IsSerialized = false;
	}

	function getBrother()
	{
		if (this.getContainer() == null)
		{
			return null;
		}
		if (this.getContainer().getActor() == null)
		{
			return null;
		}

		return this.getContainer().getActor();
	}

	function getVeteranLevel()
	{
		if (this.World.Assets.getOrigin().getID() == "scenario.manhunters" && this.getBrother().getBackground().getID() == "background.slave")
		{
			return 7;
		}

		return 11;
	}

	function isHidden()
	{
		if (("State" in this.Tactical) && this.Tactical.State != null)
		{
			return true;
		}
		if (this.World.Assets.getOrigin() == null)
		{
			return true;
		}
		if (this.getBrother() == null)
		{
			return true;
		}
		if (this.getBrother().getBackground() == null)
		{
			return true;
		}
		if (this.getBrother().getLevel() > this.getVeteranLevel())
		{
			return true;
		}
		if (this.getBrother().getLevel() == this.getVeteranLevel() && this.getBrother().getLevelUps() == 0)
		{
			return true;
		}

		return false;
	}

	function onUpdate(_properties)
	{
		this.m.IsHidden = this.isHidden();
	}

	function getTooltip()
	{
		local brotherClone = this.getBrother().getBaseProperties().getClone();
		local excludedIDs = [
			"excluded.veteran_attributes" //placeholder
		];
		local includedIDs = [
			"effects.kraken_potion",
			"effects.apotheosis_potion"
		];
		foreach (skill in this.getBrother().getSkills().m.Skills)
		{
			if (skill.isGarbage() || excludedIDs.find(skill.getID()) != null)
			{
				continue;
			}
			if (skill.isType(this.Const.SkillType.Trait) || skill.isType(this.Const.SkillType.Perk) || skill.isType(this.Const.SkillType.PermanentInjury) || includedIDs.find(skill.getID()) != null)
			{
				skill.onUpdate(brotherClone);
			}
		}

		local levelUps = Math.max(this.getVeteranLevel() - this.getBrother().getLevel() + this.getBrother().getLevelUps(), 0);
		local hitpointsMin = levelUps * (this.Const.AttributesLevelUp[this.Const.Attributes.Hitpoints].Min + Math.min(this.getBrother().m.Talents[this.Const.Attributes.Hitpoints], 2));
		local hitpointsMax = levelUps * (this.Const.AttributesLevelUp[this.Const.Attributes.Hitpoints].Max + (this.getBrother().m.Talents[this.Const.Attributes.Hitpoints] == 3 ? 1 : 0));
		local braveryMin = levelUps * (this.Const.AttributesLevelUp[this.Const.Attributes.Bravery].Min + Math.min(this.getBrother().m.Talents[this.Const.Attributes.Bravery], 2));
		local braveryMax = levelUps * (this.Const.AttributesLevelUp[this.Const.Attributes.Bravery].Max + (this.getBrother().m.Talents[this.Const.Attributes.Bravery] == 3 ? 1 : 0));
		local staminaMin = levelUps * (this.Const.AttributesLevelUp[this.Const.Attributes.Fatigue].Min + Math.min(this.getBrother().m.Talents[this.Const.Attributes.Fatigue], 2));
		local staminaMax = levelUps * (this.Const.AttributesLevelUp[this.Const.Attributes.Fatigue].Max + (this.getBrother().m.Talents[this.Const.Attributes.Fatigue] == 3 ? 1 : 0));
		local initiativeMin = levelUps * (this.Const.AttributesLevelUp[this.Const.Attributes.Initiative].Min + Math.min(this.getBrother().m.Talents[this.Const.Attributes.Initiative], 2));
		local initiativeMax = levelUps * (this.Const.AttributesLevelUp[this.Const.Attributes.Initiative].Max + (this.getBrother().m.Talents[this.Const.Attributes.Initiative] == 3 ? 1 : 0));
		local meleeSkillMin = levelUps * (this.Const.AttributesLevelUp[this.Const.Attributes.MeleeSkill].Min + Math.min(this.getBrother().m.Talents[this.Const.Attributes.MeleeSkill], 2));
		local meleeSkillMax = levelUps * (this.Const.AttributesLevelUp[this.Const.Attributes.MeleeSkill].Max + (this.getBrother().m.Talents[this.Const.Attributes.MeleeSkill] == 3 ? 1 : 0));
		local rangedSkillMin = levelUps * (this.Const.AttributesLevelUp[this.Const.Attributes.RangedSkill].Min + Math.min(this.getBrother().m.Talents[this.Const.Attributes.RangedSkill], 2));
		local rangedSkillMax = levelUps * (this.Const.AttributesLevelUp[this.Const.Attributes.RangedSkill].Max + (this.getBrother().m.Talents[this.Const.Attributes.RangedSkill] == 3 ? 1 : 0));
		local meleeDefenseMin = levelUps * (this.Const.AttributesLevelUp[this.Const.Attributes.MeleeDefense].Min + Math.min(this.getBrother().m.Talents[this.Const.Attributes.MeleeDefense], 2));
		local meleeDefenseMax = levelUps * (this.Const.AttributesLevelUp[this.Const.Attributes.MeleeDefense].Max + (this.getBrother().m.Talents[this.Const.Attributes.MeleeDefense] == 3 ? 1 : 0));
		local rangedDefenseMin = levelUps * (this.Const.AttributesLevelUp[this.Const.Attributes.RangedDefense].Min + Math.min(this.getBrother().m.Talents[this.Const.Attributes.RangedDefense], 2));
		local rangedDefenseMax = levelUps * (this.Const.AttributesLevelUp[this.Const.Attributes.RangedDefense].Max + (this.getBrother().m.Talents[this.Const.Attributes.RangedDefense] == 3 ? 1 : 0));
		local brotherAttributes = {
			Hitpoints = [
				Math.floor((brotherClone.Hitpoints + hitpointsMin) * ((brotherClone.Hitpoints + hitpointsMin) >= 0 ? brotherClone.HitpointsMult : 1.0 / brotherClone.HitpointsMult)),
				Math.floor((brotherClone.Hitpoints + hitpointsMax) * ((brotherClone.Hitpoints + hitpointsMax) >= 0 ? brotherClone.HitpointsMult : 1.0 / brotherClone.HitpointsMult))
			],
			Bravery = [
				Math.floor((brotherClone.Bravery + braveryMin) * ((brotherClone.Bravery + braveryMin) >= 0 ? brotherClone.BraveryMult : 1.0 / brotherClone.BraveryMult)),
				Math.floor((brotherClone.Bravery + braveryMax) * ((brotherClone.Bravery + braveryMax) >= 0 ? brotherClone.BraveryMult : 1.0 / brotherClone.BraveryMult))
			],
			Stamina = [
				Math.floor((brotherClone.Stamina + staminaMin) * ((brotherClone.Stamina + staminaMin) >= 0 ? brotherClone.StaminaMult : 1.0 / brotherClone.StaminaMult)),
				Math.floor((brotherClone.Stamina + staminaMax) * ((brotherClone.Stamina + staminaMax) >= 0 ? brotherClone.StaminaMult : 1.0 / brotherClone.StaminaMult))
			],
			Initiative = [
				Math.floor((brotherClone.Initiative + initiativeMin) * ((brotherClone.Initiative + initiativeMin) >= 0 ? brotherClone.InitiativeMult : 1.0 / brotherClone.InitiativeMult)),
				Math.floor((brotherClone.Initiative + initiativeMax) * ((brotherClone.Initiative + initiativeMax) >= 0 ? brotherClone.InitiativeMult : 1.0 / brotherClone.InitiativeMult))
			],
			MeleeSkill = [
				Math.floor((brotherClone.MeleeSkill + meleeSkillMin) * ((brotherClone.MeleeSkill + meleeSkillMin) >= 0 ? brotherClone.MeleeSkillMult : 1.0 / brotherClone.MeleeSkillMult)),
				Math.floor((brotherClone.MeleeSkill + meleeSkillMax) * ((brotherClone.MeleeSkill + meleeSkillMax) >= 0 ? brotherClone.MeleeSkillMult : 1.0 / brotherClone.MeleeSkillMult))
			],
			RangedSkill = [
				Math.floor((brotherClone.RangedSkill + rangedSkillMin) * ((brotherClone.RangedSkill + rangedSkillMin) >= 0 ? brotherClone.RangedSkillMult : 1.0 / brotherClone.RangedSkillMult)),
				Math.floor((brotherClone.RangedSkill + rangedSkillMax) * ((brotherClone.RangedSkill + rangedSkillMax) >= 0 ? brotherClone.RangedSkillMult : 1.0 / brotherClone.RangedSkillMult))
			],
			MeleeDefense = [
				Math.floor((brotherClone.MeleeDefense + meleeDefenseMin) * ((brotherClone.MeleeDefense + meleeDefenseMin) >= 0 ? brotherClone.MeleeDefenseMult : 1.0 / brotherClone.MeleeDefenseMult)),
				Math.floor((brotherClone.MeleeDefense + meleeDefenseMax) * ((brotherClone.MeleeDefense + meleeDefenseMax) >= 0 ? brotherClone.MeleeDefenseMult : 1.0 / brotherClone.MeleeDefenseMult))
			],
			RangedDefense = [
				Math.floor((brotherClone.RangedDefense + rangedDefenseMin) * ((brotherClone.RangedDefense + rangedDefenseMin) >= 0 ? brotherClone.RangedDefenseMult : 1.0 / brotherClone.RangedDefenseMult)),
				Math.floor((brotherClone.RangedDefense + rangedDefenseMax) * ((brotherClone.RangedDefense + rangedDefenseMax) >= 0 ? brotherClone.RangedDefenseMult : 1.0 / brotherClone.RangedDefenseMult))
			]
		};

		local calcSpacing = function(_range)
		{
			local count = 0;
			foreach (att in _range)
			{
				if (att == 0) count += 2;
				if (att < 0) count += 1;
				while (Math.abs(att) != 0)
				{
					att = Math.floor(Math.abs(att) / 10);
					count += 2;
				}
			}

			local spacing = "";
			for (local i = 0; i < 20 - count; i++)
			{
				spacing += "&nbsp;";
			}
			return spacing;
		}

		local tooltip = [
		{
			id = "veteran_attributes_0",
			type = "title",
			text = "Характеристики ветерана " + this.getVeteranLevel()
		},
		{
			id = "veteran_attributes_1",
			type = "description",
			text = "Максимальные характеристики этого персонажа на уровне " + this.getVeteranLevel() + ", включая любые бонусы или штрафы от его черт, навыков и постоянных травм. Диапазон рассчитывается путем улучшения каждой характеристики при каждом повышении уровня, пока не будет достигнут уровень ветерана."
		},
		{
			id = "veteran_attributes_2",
			type = "hint",
			text = "Максимальные значения характеристик на уровне " + this.getVeteranLevel() + ":"
		},
		{
			id = "veteran_attributes_3",
			type = "hint",
			text = "[img]gfx/mods/veteran_attributes/health.png[/img] " + brotherAttributes.Hitpoints[0] + " - " + brotherAttributes.Hitpoints[1] + calcSpacing(brotherAttributes.Hitpoints) + "[img]gfx/mods/veteran_attributes/melee_skill.png[/img] " + brotherAttributes.MeleeSkill[0] + " - " + brotherAttributes.MeleeSkill[1]
		},
		{
			id = "veteran_attributes_4",
			type = "hint",
			text = "[img]gfx/mods/veteran_attributes/fatigue.png[/img] " + brotherAttributes.Stamina[0] + " - " + brotherAttributes.Stamina[1] + calcSpacing(brotherAttributes.Stamina) + "[img]gfx/mods/veteran_attributes/ranged_skill.png[/img] " + brotherAttributes.RangedSkill[0] + " - " + brotherAttributes.RangedSkill[1]
		},
		{
			id = "veteran_attributes_5",
			type = "hint",
			text = "[img]gfx/mods/veteran_attributes/bravery.png[/img] " + brotherAttributes.Bravery[0] + " - " + brotherAttributes.Bravery[1] + calcSpacing(brotherAttributes.Bravery) + "[img]gfx/mods/veteran_attributes/melee_defense.png[/img] " + brotherAttributes.MeleeDefense[0] + " - " + brotherAttributes.MeleeDefense[1]
		},
		{
			id = "veteran_attributes_6",
			type = "hint",
			text = "[img]gfx/mods/veteran_attributes/initiative.png[/img] " + brotherAttributes.Initiative[0] + " - " + brotherAttributes.Initiative[1] + calcSpacing(brotherAttributes.Initiative) + "[img]gfx/mods/veteran_attributes/ranged_defense.png[/img] " + brotherAttributes.RangedDefense[0] + " - " + brotherAttributes.RangedDefense[1]
		}];

		return tooltip;
	}
});
