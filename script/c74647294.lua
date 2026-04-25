--Scarlet Devil Mansion
local s,id=GetID()
function s.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_SET)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
    e1:SetOperation(s.setop)
    c:RegisterEffect(e1)
    --ATK/DEF up
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_UPDATE_ATTACK)
    e2:SetRange(LOCATION_FZONE)
    e2:SetTargetRange(LOCATION_MZONE,0)
    e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x322))
    e2:SetCondition(s.atkdefcon)
    e2:SetValue(600)
    c:RegisterEffect(e2)
    local e3=e2:Clone()
    e3:SetCode(EFFECT_UPDATE_DEFENSE)
    c:RegisterEffect(e3)
    --Special Summon
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(id,1))
    e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e4:SetProperty(EFFECT_FLAG_DELAY|EFFECT_FLAG_CARD_TARGET)
    e4:SetCode(EVENT_DESTROYED)
    e4:SetCountLimit(1,id)
    e4:SetCondition(s.spcon)
    e4:SetTarget(s.sptg)
    e4:SetOperation(s.spop)
    c:RegisterEffect(e4)
    Duel.AddCustomActivityCounter(id,ACTIVITY_CHAIN,s.chainfilter)
end
s.listed_series={0x322}
function s.chainfilter(re,tp,cid)
    return not re:IsActiveType(TYPE_SPELL+TYPE_TRAP)
end
function s.setfilter(c)
    return c:IsSetCard(0x322) and c:IsQuickPlaySpell() and c:IsSSetable()
end
function s.setop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(s.setfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil,e,tp)
    if #g>0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 
        and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
        local sg=g:Select(tp,1,1,nil)
        Duel.SSet(tp,sg)
    end
end
function s.atkdefcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetCustomActivityCount(id,1-e:GetHandlerPlayer(),ACTIVITY_CHAIN)>0
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return c:IsPreviousLocation(LOCATION_FZONE) and c:IsReason(REASON_EFFECT)
end
function s.spfilter(c,e,tp)
    return c:IsMonster() and c:IsAttribute(ATTRIBUTE_DARK) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_GRAVE|LOCATION_REMOVED) and chkc:IsControler(tp) and s.spfilter(chkc,e,tp) end
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingTarget(s.spfilter,tp,LOCATION_GRAVE|LOCATION_REMOVED,0,1,nil,e,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectTarget(tp,s.spfilter,tp,LOCATION_GRAVE|LOCATION_REMOVED,0,1,1,nil,e,tp)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        Duel.SpecialSummon(tc,0,tp,tp,true,false,POS_FACEUP)
    end
end