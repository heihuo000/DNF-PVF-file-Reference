//////////////////////////////////////////////////////////
//@ mkjung create date: 20120625
//@ application uses: Resource Tool 
//@ uses part: ITEM, Avatarlist Equipment Script Grammer Check Sample
//////////////////////////////////////////////////////////

//1 조건(if)##########################
[if] 	
	//####1.1.1 trigger ######
	//1.1.1.1 attack success #
	{exp}공격 성공시의 값{/exp}[attack success]
		{must1}{exp}값이 2의 경우 attack condition 의 stuck 사용{/exp}{int(1:2)}
	[!attack success]
	
	//1.1.1.2 check damage #
	{exp}피격시 총 HP의 깍이는 데미지 %{/exp}[check damage]
		{must1}{exp}% 또는 +{/exp}{string}
		{must2}{exp}수치{/exp}{int(0:)}
	[!check damage]

	//1.1.1.3 event attack success #
	{prereq}[increase damage]|[increase critical damage]|[eakness]{/prereq}{exp} increase damage,increase critical damage,weakness태그와 조합할때만 사용한다{/exp}[event attack success]
		{must1}{exp}공격 성공시의 값{/exp}{int(0:)}
	[!event attack success]

	//1.1.1.4 after attack #
	{prereq}[combo]|[aerial]{/prereq}{exp}combo,aerial 태그와 조합할때만 사용{/exp}[after attack]
		{must1}{exp}공격 성공시의 값{/exp}{int(0:)}
	[!after attack]

	//1.1.1.5 hit #
	[hit]
		{must1}{exp}피격당했을때의 값{/exp}{int(0:)}
	[!hit]

	//1.1.1.6 event hit #
	[event hit]
		{must1}{exp}피격당했을때의 값{/exp}{int(0:)}
	[!event hit]

	//1.1.1.7 my active status on #
	[my active status on]
		{must1}{exp}상태변화{/exp}{string)}
	[!my active status on]

	//1.1.1.8 casting #
	[casting]
		{must1}{exp}캐스트 스킬 사용시 경우 체크{/exp}{int(0:)}
	[!casting]

	//1.1.1.9 use skill #
	[use skill]
		{must1}{exp}직업{/exp}{string)}
		{must2}{exp}스킬의 번호{/exp}{int(0:)}
	[!use skill]

	//1.1.1.10 event use skill #
	[event use skill]
		{must1}{exp}직업{/exp}{string)}
		{must2}{exp}스킬의 번호{/exp}{int(0:)}
	[!event use skill]
	
	//1.1.1.11  my death #(tag disuse)
	//2010-02-10 이후로 사용을 금지
	
	//1.1.1.12 party death #
	{exp}파티원이 죽었을 때를 지정{/exp}[party death]
		{must1}{exp}{/exp}{int(1:1)}
	[!party death]

	//1.1.1.13 use command #
	{exp}커맨드를 입력했을 때를 지정{/exp}[use command]
		{must1}{exp}{/exp}{int(1:1)}
	[!use command]

	//1.1.1.14 revive #
	{exp}내가 부활했을 때를 지정{/exp}[revive]
		{must1}{exp}{/exp}{int(1:1)}
	[!revive]

	//1.1.1.15 time #	
	[time]
		{must1}{exp}시간텀{/exp}{int(0:)}
		{must2}{exp}루프 여부{/exp}{int(0:1)}
		{must3}{exp}선쿨시간 {/exp}{int(0:)}
	[!time]

	//1.1.1.16 set my state #
	{exp}내 상태가 변경됐을 때를 지정{/exp}[set my state]
		{must1}{exp}{/exp}{int(1:1)}
	[!set my state]

	//1.1.1.17 change status #
	{exp}조건이 해당될 때 옵션 적용{/exp}[change status]
		{must1}{exp}스탯{/exp}{string}
		{must2}{exp}비교방법{/exp}{string}
		{must3}{exp}비교단위{/exp}{string}
		{must4}{exp}수치{/exp}{int(0:)}
	[!change status]

	//1.1.1.18 change status in range #
	{prereq}[apply status in range]{/prereq}{exp}수치1~수치2에 해당될때 옵션 적용{/exp}[change status in range]
		{must1}{exp}스탯{/exp}{string}
		{must2}{exp}수치1{/exp}{int(0:)}
		{must3}{exp}수치2{/exp}{int(0:)}
	[!change status in range]

	//1.1.1.19 skill frame trigger #
	[skill frame trigger]
		{must1}{exp}직업{/exp}{string}
		{must2}{exp}스킬 인덱스{/exp}{int(0:)}
		{must3}{exp}애니메이션 명{/exp}{string}
		{must4}{exp}프레임{/exp}{int(0:)}
	[!skill frame trigger]

	//####1.1.2 state ######
	//1.1.2.1 module #
	{exp}모듈{/exp}[module]
		{string}
		{!string}
	[/module]

	//1.1.2.2 attacker #
	{exp}공격성공시 공격타입을 제어{/exp}[attacker]
		{must1}{exp}타입{/exp}{string}
		{must2}{exp}스킬 인덱스{/exp}{int(0:)}
	[!attacker]

	//1.1.2.3 element #
	{prereq}[attack success]|[hit]{/prereq}{exp}공격성공시 공격타입을 제어{/exp}[element]
		{must1}{exp}속성{/exp}{string}
	[!element]

	//1.1.2.4 character #
	{exp}자신이 해당 직업일경우만 조건을 체크{/exp}[character]
		{must1}{exp}직업{/exp}{string}
	[!character]
	
	//1.1.2.5 distance #
	{prereq}[attack success]|[hit]{/prereq}{exp}거리{/exp}[distance]
		{must1}{exp}{/exp}{int(0:)}
	[!distance]

	//1.1.2.6 my active status #
	{exp}내 상태변화를 체크{/exp}[my active status]
		{must1}{exp}상태{/exp}{string}
	[!my active status]

	//1.1.2.7 my state #
	{exp}내 상태를 체크{/exp}[my state]
		{must1}{exp}상태{/exp}{string}
	[!my state]

	//1.1.2.8 target state #
	{exp}적 상태를 체크{/exp}[target state]
		{must1}{exp}상태{/exp}{string}
	[!target state]

	//1.1.2.9 target active status #
	{exp}내가 타격하는 적의 상태변화 체크{/exp}[target active status]
		{must1}{exp}상태변화{/exp}{string}
	[!target active status]

	//1.1.2.10 attack type #
	{prereq}[attack success]|[hit]{/prereq}{exp}{/exp}[attacker type]
		{must1}{exp}타입{/exp}{string}
	[!attacker type]

	//1.1.2.11 target type #
	{prereq}[attack success]{/prereq}{exp}내가 타격하는 적의 타입을 체크{/exp}[target type]
		{must1}{exp}타입{/exp}{string}
	[!target type]

	//1.1.2.12 target grade #
	{prereq}[attack success]{/prereq}{exp}내가 타격하는 적의 등급을 체크{/exp}[target grade]
		{must1}{exp}등급{/exp}{string}
	[!target grade]

	//1.1.2.13 attack condition #
	{prereq}[attack success]|[hit]{/prereq}[attack condition]
		{must1}{exp}타격조건{/exp}{string}
	[!attack condition]

	//1.1.2.14 skill #
	{prereq}[attack success]|[hit]{/prereq}[skill]
		{must1}{exp}직업{/exp}{string}
		{must2}{exp}스킬 인덱스{/exp}{int(0:)}
	[!skill]

	//1.1.2.15 stat change #
	[stat change]
		{must1}{exp}스탯{/exp}{string}
		{must2}{exp}비교방법{/exp}{string}
		{must3}{exp}비교단위{/exp}{string}
		{must4}{exp}수치{/exp}{int(0:)}
	[!stat change]

	//1.1.2.16 target stat #
	[target stat]
		{must1}{exp}스탯{/exp}{string}
		{must2}{exp}비교방법{/exp}{string}
		{must3}{exp}비교단위{/exp}{string}
		{must4}{exp}수치{/exp}{int(0:)}
	[!target stat]

	//1.1.2.17 cooltime #
	{exp}쿨타임 동안 조건을 체크 안함{/exp}[cooltime]
		{must1}{exp}쿨타임 단위: ms{/exp}{int(0:)}
	[!cooltime]

	//1.1.2.18 start cooltime #
	{exp}장착 시 마다 해당 쿨타임이 적용{/exp}[start cooltime]
		{must1}{exp}쿨타임 단위: ms{/exp}{int(0:)}
	[!start cooltime]

	//1.1.2.19 target death #
	{prereq}[attack success]{/prereq}{exp}내가 타격하는 적이 죽었을 때를 지정{/exp}[target death]
		{must1}{exp}{/exp}{int(1:1)}
	[!target death]

	//1.1.2.20 combo #
	{exp}콤보가 수치 만큼 도달했을 때를 지정한다{/exp}[combo]
		{must1}{exp}수치{/exp}{int(0:)}
	[!combo]

	//1.1.2.21 aerial #
	{exp}에어리얼 콤보가 수치에 도달했을 때를 지정{/exp}[aerial]
		{must1}{exp}{/exp}{string}
	[!aerial]

	//1.1.2.22 overkill #
	{exp}내가 타격하는 적이 오버킬로 죽였을 때를 지정{/exp}[overkill]
		{must1}{exp}{/exp}{string}
	[!overkill]

	//1.1.2.23 party count #
	{exp}파티원 카운트{/exp}[party count]
		{must1}{exp}카운트{/exp}{int(0:)}
	[!party count]

	//1.1.2.24 my appendage #
	{exp}나에게 n번 어펜디지가 붙어있을때를 체크{/exp}[my appendage]
		{must1}{exp}어펜디지 인덱스{/exp}{int(0:)}
	[!my appendage]

	//1.1.2.25 skill frame state #
	{exp}해당 애니메이션의 시작~끝 프레임 사이에서 성공.{/exp}[skill frame state]
		{must1}{exp}직업{/exp}{string}
		{must2}{exp}스킬 인덱스{/exp}{int(0:)}
		{must3}{exp}애니메이션 명{/exp}{string}
		{must4}{exp}시작 프레임{/exp}{int(0:)}
		{must5}{exp}끝 프레임{/exp}{int(0:)}
	[!skill frame state]

	//1.1.2.26 skill cooltime  #
	{exp}스킬 초기화 범위를 제약을 위한 state{/exp}[skill cooltime]
		{must1}{exp}비교방법{/exp}{string}
		{must2}{exp}쿨타임{/exp}{int(0:)}
	[!skill cooltime]

[/if] 

//2 효과(than)##########################
[then] 
	//1.2.1 consume item #
	{exp}해당 인덱스의 아이템을 소모{/exp}[consume item ]
		{must1}{exp}인덱스{/exp}{int(0:)}
		{must2}{exp}개수{/exp}{int(0:)}
	[!consume item ]
	
	//1.2.2 target #
	{exp}효과를 어떤 대상에게 일어나게 할 지 타겟을 지정{/exp}[target]
		{must1}{exp}종류{/exp}{string}
		{must2}{exp}범위(단위: px){/exp}{int(0:)}
	[!target]

	//1.2.3 duration #
	{exp}효과가 얼마나 지속되는지를 지정{/exp}[duration]
		{must1}{exp}수치(단위 : ms){/exp}{int(0:)}
	[!duration]

	//1.2.4 equipment duration #
	{exp}효과가 얼마나 지속되는지를 지정{/exp}[equipment duration]
		{must1}{exp}수치(단위 : ms){/exp}{int(0:)}
	[!equipment duration]

	//1.2.5 delay #
	{exp}효과가 얼마의 딜레이를 두고 발동하는지를 지정{/exp}[delay]
		{must1}{exp}수치(단위 : ms){/exp}{int(0:)}
	[!delay]

	//1.2.6 probability #
	{exp}효과가 발동될 확률을 지정{exp}[probability]
		{must1}{exp}디폴트 100{/exp}{int(0:)}
	[!probability]

	//1.2.7 active status #
	{exp}{/exp}[active status]
		{must1}{exp}상태변화{/exp}{string}
		{opt1}{exp}레벨{/exp}{int(0:)}
		{opt2}{exp}강도{/exp}{int(0:)}
	[!active status]

	//1.2.8 disenchant #
	{exp}타겟의 보든 상태변화와 버프를 제거{/exp}[disenchant]
		{must1}{exp}{/exp}{int(1:1)}
	[!disenchant]

	//1.2.9 buff #
	[buff]
		{must1}{exp}종류{/exp}{string}
		{must2}{exp}레벨{/exp}{int(0:)}
	[!buff]

	//1.2.10 appendage #
	{exp}타겟에게 해당 인덱스의 버프를 건다{/exp}[appendage]
		{must1}{exp}인덱스{/exp}{int(0:)}
	[!appendage]

	//1.2.11 add absolute damage #
	[add absolute damage]
		{must1}{exp}타입{/exp}{string}
		{must2}{exp}수치단위{/exp}{string}
		{must3}{exp}수치{/exp}{int(0:)}
	[!add absolute damage]

	//1.2.12 increase damage #
	[increase damage]
		{must1}{exp}비율 {/exp}{string}
		{must2}{exp}수치{/exp}{int(0:)}
	[!increase damage]

	//1.2.13 increase critical damage #
	[increase critical damage]
		{must1}{exp}비율 {/exp}{string}
		{must2}{exp}수치{/exp}{int(0:)}
	[!increase critical damage]
	
	//1.2.14 weakness #
	[weakness]
		{must1}{exp}수치{/exp}{int(0:)}
	[!weakness]

	//1.2.15 add absolute defence #
	[add absolute defence]
		{must1}{exp}타입{/exp}{string}
		{must2}{exp}수치단위{/exp}{string}
		{must3}{exp}수치{/exp}{int(0:)}
	[!add absolute defence]

	//1.2.16 add absolute defence percent #
	{exp}피격시 데미지를 수치% 많큼 줄여준다{/exp}[add absolute defence percent]
		{must1}{exp}타입{/exp}{string}
		{must2}{exp}수치{/exp}{int(0:)}
	[!add absolute defence percent]

	//1.2.17 aura active #
	[aura active]
		{must1}{exp}오우라종류{/exp}{string}
		{must2}{exp}수치단위{/exp}{string}
		{must3}{exp}수치{/exp}{int(0:)}
		{must4}{exp}오우라범위(X축으로의 픽셀단위 수치){/exp}{int(0:)}
	[!aura active]

	//1.2.18 stat #
	[stat]
		{must1}{exp}스탯종류{/exp}{string}
		{must2}{exp}수치단위{/exp}{string}
		{must3}{exp}수치{/exp}{int(0:)}
	[!stat]

	//1.2.19 restore #
	[restore]
		{must1}{exp}스탯종류{/exp}{string}
		{must2}{exp}수치단위{/exp}{string}
		{must3}{exp}수치{/exp}{int(0:)}
		{must4}{exp}회복속도: 시간(단위:ms){/exp}{int(0:)}
	[!restore]

	//1.2.20 active status resistance #
	[active status resistance]
		{must1}{exp}상태변화 {/exp}{string}
		{must2}{exp}수치단위{/exp}{string}
		{must3}{exp}수치{/exp}{int(0:)}
	[!active status resistance]

	//1.2.21 element resistance #
	[element resistance]
		{must1}{exp}속성{/exp}{string}
		{must2}{exp}수치단위{/exp}{string}
		{must3}{exp}수치{/exp}{int(0:)}
	[!element resistance]

	//1.2.22 damage rate(미구현) #
	[damage rate]
		{must1}{exp}종류{/exp}{string}
		{must2}{exp}수치 : 퍼센트 변화값{/exp}{int(0:)}
	[!damage rate]

	//1.2.23 summon monster #
	[summon monster]
		{must1}{exp}인덱스{/exp}{string}
		{must2}{exp}레벨{/exp}{string}
		{must3}{exp}최대수{/exp}{int(0:)}
	[!summon monster]

	//1.2.24 passive object #
	[passive object]
		{must1}{exp}인덱스{/exp}{int(0:)}
		{must2}{exp}x축좌표{/exp}{int(0:)}
		{must3}{exp}y축좌표{/exp}{int(0:)}
		{must4}{exp}z축좌표{/exp}{int(0:)}
		{must5}{exp}레벨 {/exp}{int(0:)}
		{must6}{exp}파일명 {/exp}{string}
	[!passive object]

	//1.2.25 skill #
	[skill]
		{must1}{exp}직업{/exp}{string}
		{must2}{exp}스킬인덱스{/exp}{int(0:)}
		{must3}{exp}레벨{/exp}{int(0:)}
	[!skill]

	//1.2.26 skill levelup #
	[skill levelup]
		{exp}직업{/exp}{string}
			{must1}{exp}스킬인덱스{/exp}{int(0:)}
			{must2}{exp}레벨변화량 {/exp}{int(0:)}
		{!string}
	[/skill levelup]

	//1.2.27 thorn #
	{prereq}적에게 데미지를 퍼센트로 돌려줌{/prereq}{exp}적에게 데미지를 퍼센트로 돌려{/exp}[thorn]
		{must1}{exp}수치{/exp}{int(0:)}
	[!thorn]

	//1.2.28 knockback #
	[knockback]
		{must1}{exp}수치{/exp}{int(0:)}
	[!knockback]

	//1.2.29 reduction #
	[reduction]
		{must1}{exp}종류{/exp}{string}
		{must2}{exp}내구도를 감소시킬 수치{/exp}{int(0:)}
	[!reduction]

	//1.2.30 elemental weapon #
	{exp}무기에 속성을 부여{/exp}[elemental weapon]
		{must1}{exp}속성{/exp}{string}
	[!elemental weapon]

	//1.2.31 stat by condition #
	{exp}•버프 아이콘이 실시간으로 나오도록 함{/exp}[stat by condition]
		{must1}{exp}스탯종류{/exp}{string}
		{must2}{exp}수치단위{/exp}{string}
		{must3}{exp}수치{/exp}{int(0:)}
	[!stat by condition]

	//1.2.32 apply status in range #
	[apply status in range]
		{must1}{exp}스탯종류{/exp}{string}
		{must2}{exp}수치단위{/exp}{string}
		{must3}{exp}수치1{/exp}{int(0:)}
		{must4}{exp}수치2{/exp}{int(0:)}
	[!apply status in range]

	//1.2.33 skill super armor  #
	{exp}스킬 시전 모션이 슈퍼아머 상태가 되도록 함{/exp}[skill super armor]
		{must1}{exp}직업{/exp}{string}
		{must2}{exp}스킬인덱스{/exp}{int(0:)}
	[!skill super armor]

	//1.2.34 skill unbreakable  #
	{exp}스킬 시전 모션이 무적 상태가 되도록 함{/exp}[skill unbreakable]
		{must1}{exp}스킬인덱스{/exp}{int(0:)}
	[!skill unbreakable]

	//1.2.35 skill duration  #
	[skill duration]
		{must1}{exp}직업{/exp}{string}
		{must2}{exp}스킬인덱스{/exp}{int(0:)}
		{must3}{exp}적용파라미터{/exp}{string}
		{must4}{exp}파라메터 인덱스{/exp}{int(0:)}
	[!skill duration]

	//1.2.36 speech on  #
	{exp}말풍선{/exp}[speech on]
		{must1}{exp}수치1(ms){/exp}{int(0:)}
		{must2}{exp}수치2(ms){/exp}{int(0:)}
		{must3}{exp}출력내용 {/exp}{string}
	[!speech on]

	//1.2.37 skill cooltime reset  #
	{exp}스킬쿨타임 초기화{/exp}[skill cooltime reset]
		{must1}{exp}{/exp}{int(1:2)}
	[!skill cooltime reset]
[/then] 

///////////////////////////////////////////////////////////////
//EquipmentSample.equ/////////////////////////////////////////////
///////////////////////////////////////////////////////////////
[character name y revision]
	{must1}{int(0:)}
	{must2}{int(0:)}
[!character name y revision]

[effect]
	[attach target]
		{opt1}{string}
	[!attach target]

	[type]
		{must1}{string}
	[!type]

	[attach pos]
		{must1}{string}
	[!attach pos]

	[z revision]
		{must1}{int(:)}
	[!z revision]
	
	[index]
		{must1}{int(:)}
	[!index]

	[option]	
		{string}
		{!string}
	[/option]

	[module]
		{must1}{string}
	[!module]

	[file name]
		{must1}{string}
	[!file name]
[/effect]


[change type ultimateSkillCurScene]
	{must1}{int(0:)}
[!change type ultimateSkillCurScene]

///////////////////////////////////////////////////////////////
//EquipmentSample-change status on change hp.equ///////////////////////
///////////////////////////////////////////////////////////////
[change status on change hp]
	{opt1}{exp}적용될 능력치{/exp}{string}
	{int(:)}
		{must1}{int(:)}
	{!int(:)}
[/change status on change hp]

///////////////////////////////////////////////////////////////
//EquipmentSample-gunnerweapon.equ//////////////////////////////////
///////////////////////////////////////////////////////////////
{exp}하드코딩에서 사용하는 커스텀 애니메이션 파일 이름들{/exp}[custom animation]
	{string}
	{!string}
[!custom animation]

[piercing resistance]
	{must1}{int(0:)}
[!piercing resistance]

[jump power]
	{must1}{int(0:)}
[!jump power]

{exp}공격 보정값{/exp}[elemental property]
	{opt1}{string}
[!elemental property]

[push aside]
	{must1}{int(0:)}
[!push aside]

[lift up]
	{must1}{int(0:)}
[!lift up]

[ignore defense]
	{must1}{int(0:)}
[!ignore defense]

{exp}커스텀 효과음 리스트{/exp}[custom wav]
	{string}
	{!string}
[/custom wav]

{exp}하드코딩용 정수 자료들{/exp}[int data]
	{int(:)}
	{!int(:)}
[/int data]

{exp}하드코딩용 문자열 자료들{/exp}[string data]
	{string}
	{!string}
[/string data]

{exp}하드코딩용 정수 자료들{/exp}[float data]
	{float(:)}
	{!float(:)}
[/float data]

////////////////////////////////////////////////////////////////////////////
// [set~]
// 태그자체로만 사용가능하도록..
// [ME] 처럼.
// (그럴려면 라인태그 여야하고 인수는 생략해도 무관하도록 opt처리)
// 예외 set item (인수 : n int값 리스트 -> int line tag가 sub tag여서 /(block tag)처리
////////////////////////////////////////////////////////////////////////////
[set name]
	{opt1}{string}
[!set name]

{exp}아이템과 셋트를 이루는 아이템 인덱스들의 목록{/exp}[set item]	
	{opt1}{int(0:)}
	{!int(0:)}
[/set item]

[set item master]
	{opt1}{int(0:)}
[!set item master]

{exp}이후의 능력치들은 셋트 아이템 장착시 추가 능력치로 인식{/exp}{etc}[set ability]


///////////////////////////////////////////////////////////////////////////////
//3.1 skill data up #
//•  skill data up의 기능을 appendage화
//•	일정 시간동안 사용할 수 있도록 하는것이 목적
//[type] `skill data up` //타입 명
//[duration] 20000  // 지속시간 //  기존동일/
//[buff] 1 // 1이면 버프 아니면 0 버프가 아니면 디스인첸트로 삭제안됨 // 기존동일
//[icon image] `` 0 // 이미지 파일명, 인덱스 : 없으면 안적음 // 기존 동일
//[max overlap] 1  // 최대 중첩 가능 개수 0이면 무한 // 기존 동일

//[int data]
//`[swordman`] 1 `[all]` `[cooltime]` 0 `+` 10000 // 기존 skill data up 기능 동일 
//직업, 스킬인덱스, 적용시킬 컨텐츠, 수정할 파라메터, 파라메터 인덱스, 수치 단위, 수치
//[/int data] 

//[string data] // 안씀
//[float data
///////////////////////////////////////////////////////////////////////////////