--Scarlet Nights
local s,id=GetID()
function s.initial_effect(c)
    --Fusion Summon 1 DARK Fusion Monster (Warrior, Spellcaster, or Fiend); materials from hand or field; extra banish material from GY if Summoning a "Scarlet" monster
	local params = {fusfilter=aux.FilterBoolFunction(Card.IsRace,RACE_FIEND),extrafil=s.fextra,extraop=s.extraop,extratg=s.extratarget}
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1,id)
	e1:SetTarget(Fusion.SummonEffTG(params))
	e1:SetOperation(Fusion.SummonEffOP(params))
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
    --2 "Scarlet" monsters, add 1, place 1 on bottom of Deck
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_TODECK)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetCountLimit(1,id)
	e2:SetCost(Cost.SelfBanish)
	e2:SetTarget(s.thdtg)
	e2:SetOperation(s.thdop)
	c:RegisterEffect(e2)
end
s.listed_series={0x322}
function s.checkmat(tp,sg,fc)
	return fc:IsSetCard(0x322) or not sg:IsExists(Card.IsLocation,1,nil,LOCATION_GRAVE)
end
function s.fextra(e,tp,mg)
	if not Duel.IsPlayerAffectedByEffect(tp,CARD_SPIRIT_ELIMINATION) then
		return Duel.GetMatchingGroup(Fusion.IsMonsterFilter(Card.IsAbleToRemove),tp,LOCATION_GRAVE,0,nil),s.checkmat
	end
	return nil
end
function s.extraop(e,tc,tp,sg)
	local rg=sg:Filter(Card.IsLocation,nil,LOCATION_GRAVE)
	if #rg>0 then
		Duel.Remove(rg,POS_FACEUP,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
		sg:Sub(rg)
	end
end
function s.extratarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetPossibleOperationInfo(0,CATEGORY_REMOVE,nil,0,tp,LOCATION_GRAVE)
end
function s.thdfilter(c,e)
	return c:IsSetCard(0x322) and c:HasLevel() and (c:IsAbleToHand() or c:IsAbleToDeck())
		and c:IsCanBeEffectTarget(e)
end
function s.rescon(sg,e,tp,mg)
	return sg:GetClassCount(Card.GetLevel)==#sg and sg:FilterCount(Card.IsAbleToHand,nil)>=1
		and sg:FilterCount(Card.IsAbleToDeck,nil)>=1
end
function s.thdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local rg=Duel.GetMatchingGroup(s.thdfilter,tp,LOCATION_GRAVE,0,nil,e)
	if chk==0 then return aux.SelectUnselectGroup(rg,e,tp,2,2,s.rescon,0) end
	local g=aux.SelectUnselectGroup(rg,e,tp,2,2,s.rescon,1,tp,aux.Stringid(id,2))
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function s.thdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetTargetCards(e)
	if #g==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local hg=g:FilterSelect(tp,Card.IsAbleToHand,1,1,nil)
		if #hg==0 or Duel.SendtoHand(hg,nil,REASON_EFFECT)==0 then return end
		Duel.ConfirmCards(1-tp,hg)
		local dg=g-hg
		if #dg==0 then return end
		Duel.HintSelection(dg,true)
		Duel.SendtoDeck(dg,nil,SEQ_DECKBOTTOM,REASON_EFFECT)
	end
end
