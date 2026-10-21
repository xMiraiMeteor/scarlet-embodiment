--Patchouli the Unmoving Scarlet Librarian
--動かないスカーレット司書 パチュリー
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	--Link Materials: 2 DARK monsters, including a "Scarlet" monster
	Link.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsAttribute,ATTRIBUTE_DARK),2,nil,s.matcheck)
    --Cannot be destroyed by card effects
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetCondition(s.incon)
	e1:SetValue(1)
	c:RegisterEffect(e1)
    --Shuffle 1 DARK monster from your GY or banishment into the Deck, then you can add "Scarlet" Spell/Trap from your Deck or banishment
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,id)
	e2:SetTarget(s.tdtg)
	e2:SetOperation(s.tdop)
	c:RegisterEffect(e2)
end
s.listed_series={0x322}
--Material filter
function s.matcheck(g,lc,sumtype,tp)
	return g:IsExists(Card.IsSetCard,1,nil,0x322,lc,sumtype,tp)
end
--e1 effect code
function s.incon(e)
	return e:GetHandler():GetLinkedGroupCount()>0 
	and e:GetHandler():GetLinkedGroup():IsExists(aux.FaceupFilter(Card.IsSetCard,0x322),1,nil)
end
--e2 effect code
function s.tdfilter(c)
	--DARK monster
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_DARK) and c:IsAbleToDeck()
end
function s.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE|LOCATION_REMOVED) and s.tdfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.tdfilter,tp,LOCATION_GRAVE|LOCATION_REMOVED,0,1,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,s.tdfilter,tp,LOCATION_GRAVE|LOCATION_REMOVED,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,#g,0,0)
	Duel.SetPossibleOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK|LOCATION_REMOVED)
end
function s.thfilter(c,e,tp)
	--"Scarlet" Spell/Trap
	return c:IsSetCard(0x322) and c:IsSpellTrap() and c:IsFaceup() and c:IsAbleToHand()
end
function s.tdop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoDeck(tc,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)>0 and tc:IsLocation(LOCATION_DECK) then
		local sg=Duel.GetMatchingGroup(s.thfilter,tp,LOCATION_DECK|LOCATION_REMOVED,0,nil)
		if #sg>0 and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		sg=sg:Select(tp,1,1,nil)
		Duel.BreakEffect()
		Duel.BreakEffect()
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
