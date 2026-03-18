--Taboo "Four of a Kind"
local s,id=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
    e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
s.listed_names={89155913}
function s.cfilter(c)
	return c:IsFaceup() and c:IsCode(89155913)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>2
		and Duel.IsPlayerCanSpecialSummonMonster(tp,id+1,0,TYPES_TOKEN,600,600,4,RACE_FIEND,ATTRIBUTE_DARK) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,3,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,3,tp,0)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>2 and Duel.IsPlayerCanSpecialSummonMonster(tp,id+1,0,TYPES_TOKEN,600,600,4,RACE_FIEND,ATTRIBUTE_DARK) then
        for i=1,3 do
		    local token=Duel.CreateToken(tp,id+1)
		    Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	        local e1=Effect.CreateEffect(e:GetHandler())
	        e1:SetType(EFFECT_TYPE_SINGLE)
	        e1:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
		    e1:SetReset(RESET_EVENT|RESETS_STANDARD)
	        e1:SetValue(1)
	        token:RegisterEffect(e1,true)
        end
		Duel.SpecialSummonComplete()
	end
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetCountLimit(1)
	e2:SetReset(RESET_PHASE|PHASE_END)
	e2:SetOperation(s.desop)
	Duel.RegisterEffect(e2,tp)
	local e3=Effect.CreateEffect(e:GetHandler())
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e3:SetDescription(aux.Stringid(id,2))
	e3:SetTargetRange(1,0)
	e3:SetTarget(s.splimit)
	e3:SetReset(RESET_PHASE|PHASE_END)
	Duel.RegisterEffect(e3,tp)
end
function s.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsAttribute(ATTRIBUTE_DARK) and c:IsLocation(LOCATION_EXTRA)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_MZONE,0,nil,TYPE_TOKEN)
	Duel.Destroy(g,REASON_EFFECT)
end