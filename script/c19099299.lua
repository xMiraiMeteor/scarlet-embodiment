--Cirno the Ice Spirit of the Scarlet Lake
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
    --Link Material: 2 Level 9 or lower monsters
	Link.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsLevelBelow,9),2,2)
    --ATK down
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_ATKCHANGE)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetCountLimit(1,id)
    e1:SetCondition(s.atkcon)
    e1:SetTarget(s.atktg)
    e1:SetOperation(s.atkop)
    c:RegisterEffect(e1)
    --Cannot attack
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_CANNOT_ATTACK)
    e2:SetRange(LOCATION_MZONE)
    e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
    e2:SetTarget(s.antg)
    c:RegisterEffect(e2)
end
--e1 effect code
function s.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLinkSummoned()
end
function s.atkfilter(c)
	return c:IsFaceup() and c:HasLevel()
end
function s.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
    if chk==0 then return Duel.IsExistingTarget(s.atkfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
    Duel.SelectTarget(tp,s.atkfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if tc:IsFaceup() and tc:IsRelateToEffect(e) then
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetValue(-tc:GetLevel()*900)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD)
        tc:RegisterEffect(e1)
    end
end
--e2 effect code
function s.antg(e,c)
    return e:GetHandler():GetLinkedGroup():IsContains(c)
end
