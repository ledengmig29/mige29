local a,b,c=ui.get,ui.set,ui.reference;local d=ui.new_checkbox;local e=ui.new_hotkey;local f=ui.new_combobox;local g=ui.new_slider;local h=ui.new_multiselect;local i=ui.new_color_picker;local j=ui.reference;local k=ui.set_visible;local l=ui.set_callback;local m=client.log;local n=client.camera_angles;local o=client.trace_bullet;local p=client.draw_text;local q=client.screen_size;local r=client.set_event_callback;local s=client.delay_call;local t=client.trace_line;local u=globals.curtime;local v=globals.realtime;local w=globals.tickcount;local x=globals.tickinterval;local y=entity.is_alive;local z=entity.get_prop;local A=entity.get_local_player;local B=entity.is_enemy;local C=entity.get_player_weapon;local D=entity.get_player_weapon;local E=entity.get_players;local F=entity.hitbox_position;local G=ui.new_checkbox("AA","Fake lag","Always on")client.set_event_callback("setup_command",function(H)H.allow_send_packet=not ui.get(G)end)ui.set_visible(G,false)local I=j("MISC","Settings","sv_maxusrcmdprocessticks")local J,K=j("RAGE","Aimbot","Enabled")local L=ui.reference("RAGE","Aimbot","Minimum Damage")local M=j("RAGE","Other","Duck peek assist")local N,O=j("RAGE","Other","Double tap")local P,Q=j("AA","Fake lag","Enabled")local R=j("aa","Fake lag","Amount")local S=j("aa","Fake lag","Variance")local T=j("aa","Fake lag","Limit")local U,V=j("aa","Other","Slow motion")local W=j("aa","Other","On shot anti-aim")local X=d("AA","Fake lag","Enable Fake Lag(GIO PRIVATE EDITION)")local Y=d("AA","Fake lag","hold aim")ui.set_visible(Y,false)local Z={"Shottick correction(based salvatore fl)","Force lag on duck"}local _=h("AA","Fake lag","Extra:",Z)local a0=f("AA","Fake lag","Amount",{"Adaptive","Maximum","Jitter-Maximum"})local a1=g("AA","Fake lag","Normal limit",1,14,1,true)local a2={"Standing","Moving","In air"}local a3={"On peek"}local a4=h("AA","Fake lag","Jitter-Maximum condition",a2)local a5=g("AA","Fake lag","Send limit",1,15,1,true)local a6=h("AA","Fake lag","triggers",a3)local a7=g("AA","Fake lag","trigger limit",1,15,1,true)local a8=g("AA","Fake lag","customize shotticks corretion",1,2,1,true)local a9=g("AA","Fake lag","refine ticks",1,10,2,true)local aa=g("AA","Fake lag","fallback limits",1,15,13,true)local function ab(ac,ad)for ae,af in ipairs(ui.get(ac))do if af==ad then return true end end;return false end;local H=false;local ag=false;local function ah(ai)local H=a(ai)k(_,H)k(a8,H)end;local function aj()k(a0,false)k(a1,false)k(a4,false)k(a5,false)k(a6,false)k(a9,false)k(aa,false)end;aj()local ak=0;local al=0;local am=false;local an,ao={},true;local ap=false;local aq=0;local ar=0;local as=1;local at=false;local au={pos={},last_fl=0}local av={}local aw={count=0,extrapolated={},should_lag=false}local function ax(ay,az)return{ay[1]+az[1],ay[2]+az[2],ay[3]+az[3]}end;local aA=nil;local aB=""local aC=nil;local aD={}local aE={}local aF=nil;local aG=nil;local aH=nil;local aI=nil;local aJ=nil;local aK=""local aL=false;local aM=false;local aN=0;local aO={"CKnife","CWeaponTaser","CC4","CHEGrenade","CSmokeGrenade","CMolotovGrenade","CSensorGrenade","CFlashbang","CDecoyGrenade","CIncendiaryGrenade"}local function aP(aQ,aR)for aS=1,#aQ do if aQ[aS]==aR then return true end end;return false end;local av={}local aT={threshold=false,stored_last_shot=0,stored_item=0,onshot=0}local aU={[0]="always on",[1]="on hotkey",[2]="toggle",[3]="off hotkey"}local aV=function(self)if not am and not a(X)then return end;local aW=function(aX,aY,aZ,a_)local b0=a(aY)local b1=type(b0)local af,b2=a(aY)local b3=b2~=nil and b2 or(b1=="boolean"and tostring(b0)or b0)av[aX]=av[aX]~=nil and av[aX]or b3;if aZ then b(aY,b2~=nil and aU[a_]or a_)else if av[aX]~=nil then local b4=av[aX]if b1=="boolean"then if b4=="true"then b4=true end;if b4=="false"then b4=false end end;b(aY,b2~=nil and aU[b4]or b4)av[aX]=nil end end end;aW("refk_limit",T,self==nil and false or self,ui.get(a8))end;r("shutdown",aV)r("setup_command",function(b5)if not a(X)then return end;if not am and a(W)then return end;local b6=A()local b7=D(b6)local b8=entity.get_classname;local b9=z(b6,"m_flDuckAmount")local ba=b9<=0.78;if b7==nil or aP(aO,b8(b7))then return end;local bb=z(b7,"m_fLastShotTime")local bc=bit.band(z(b7,"m_iItemDefinitionIndex"),0xFFFF)local bd=function(b5)if not ab(_,Z[1])then b(Y,false)return end;b(Y,true)if a(M)then return false end;local be=function()local bf,bg=z(b6,"m_vecVelocity")return math.sqrt(bf^2+bg^2)~=0 end;local bh=be()and 1 or 2;if not aT.threshold and bb~=aT.stored_last_shot then aT.onshot=w()+3;if aT.onshot>w()then aT.stored_last_shot=bb;aT.threshold=true end;return true end;if aT.threshold and b5.chokedcommands>=bh then aT.threshold=false;return true end;return false end;if aT.stored_item~=bc then aT.stored_last_shot=bb;aT.stored_item=bc end;aV(bd(b5))end)local bi=false;local bj=false;local bk=true;local function bl()local bj=a(X)local bm=a(P)local bn=Q;local bo=a(R)local bp=a(S)local bq=a(T)if a(X)then if v()>=aN then if bj then if not aL and not aM then aL=true;aM=true;aA=bm;aB=bn;aE=bo;aF=bp;aG=bq end else if aL then aL=false;s(.01,function()b(P,aA)b(Q,aB)b(R,aE)b(S,aF)if aG>=15 then b(T,14)else b(T,aG)end end)end end end end;if a(X)then if aL and bj and not bi then bi=true end end;if a(X)then return end;if aL and bi then aL=false;s(.01,function()b(P,aA)b(Q,aB)b(R,aE)b(S,aF)b(T,aG)aM=false end)return end end;local br,bs,bt=0,0,0;local function bu(bv)return bv[1]*bv[1]+bv[2]*bv[2]end;local function bw(bv,bx)return{bv[1]-bx[1],bv[2]-bx[2]}end;local function by(bz)br,bs,bt=z(bz,"m_vecVelocity")return math.floor(math.min(10000,math.sqrt(br^2+bs^2)+0.5))end;local bA=A()local bB=0;r("run_command",function(b5)bA=A()if bA~=nil and b5.chokedcommands==0 then local bf,bg,bC=z(bA,"m_vecOrigin")an[ao and 0 or 1]={bf,bg}ao=not ao end;br,bs,bt=z(bA,"m_vecVelocity")if br~=nil and bs~=nil and bt~=nil then ak=math.sqrt(br^2+bs^2)bB=bt^2>0 end end)aw.should_lag=function()return aw.count>0 end;aw.reset=function()aw.count=0;aw.extrapolated={}au.pos={}end;local bD=0;aw.predict_player=function(bE,bF,bG)local bH={entity=bE,on_ground=z(bE,"m_hGroundEntity")~=nil,velocity={z(bE,"m_vecVelocity")},origin={z(bE,"m_vecOrigin")}}local bI=function(bJ)local bK=cvar.sv_gravity:get_int()local bL=cvar.sv_jump_impulse:get_int()local aT=bJ;local bM=aT.origin;local bN=x()if not aT.on_ground and not bG then local bO=bK*bN;aT.velocity[3]=aT.velocity[3]-bO end;bM=ax(bM,{aT.velocity[1]*bN,aT.velocity[2]*bN,aT.velocity[3]*bN})local bP=t(bE,aT.origin[1],aT.origin[2],aT.origin[3],bM[1],bM[2],bM[3])local bQ=t(bE,aT.origin[1],aT.origin[2],aT.origin[3],aT.origin[1],aT.origin[2],aT.origin[3]-2)if bG or bP>0.97 then aT.origin=bM;aT.on_ground=bQ==0;aw.extrapolated[#aw.extrapolated+1]=aT.origin end;return aT end;if bF>0 then bD=bF;repeat bH=bI(bH)bD=bD-1 until bD<1;return bH end end;aw.trace_positions=function(b6,bR,bS)local bT=function(b6,bR,aT)local ae,bU=o(b6,bR[1],bR[2],bR[3],aT[1],aT[2],aT[3])if ae==nil or ae==b6 or not entity.is_enemy(ae)then return false end;return bU>a(L)end;if bR[1]~=nil then for aS=1,#bS do if bS[aS][1]~=nil and bT(b6,bR,bS[aS])then return true end end end;return false end;client.set_event_callback("setup_command",function(b5)local b6=A()local bV=E(true)local bW={client.eye_position()}local bX=9;if bV==nil or bW[1]==nil then return end;aw.reset()if ak<1 then au.pos[1]=bW else local bY={z(b6,"m_vecViewOffset")}for aS=1,bX do local bZ=aw.predict_player(b6,aS,true)au.pos[aS]=ax(bZ.origin,bY)end end;for aS=1,#bV do if z(bV[aS],"m_bGunGameImmunity")==0 then local b_={{F(bV[aS],0)},{F(bV[aS],4)},{F(bV[aS],2)}}local c0,c1=false,au.pos;for aS=1,#c1 do if not c0 and aw.trace_positions(b6,c1[aS],b_)then c0=true end end;if c0 then aw.count=aw.count+1 end end end end)local c2=false;local c3=nil;local function c4()if a(M)then return end;if c2 and ak>33 then b(P,true)if a0=="Jitter-Maximum"then if a(a5)==15 and(ak>60 or ap)then b(T,15)else b(T,a(a7))end else if a(a1)==15 and(ak>60 or ap)then b(T,15)else b(T,a(a7))end end;if c3~=nil then if c3>=a(a7)then c2=false end end;return end end;local c5=0;local c6=0;local c7=true;local function c8()c7=true;if w()%c6>=c5 then b(P,true)b(T,a(a5))if a(a5)==16 and(ak>80 or ap)then b(T,15)else b(T,a(a5))end else if not shots_fired then b(T,1)if bB then b(P,false)end end end end;r("setup_command",function(b5)aq=b5.in_jump;ar=b5.in_duck end)local c9=false;local ca=false;local function cb(b5)if not a(X)then c3=0;if c9 then c9=false;b(I,17)end;am=false;return end;if ab(_,Z[3])then if a(M)then am=true;if am then if aL then b(R,"Maximum")b(S,0)b(T,15)b(refk_shoot,false)end end else if a0~="Jitter-Maximum"then b(P,true)end;am=false end else b(T,14)end;if not bi or a(O)then if c9 then c9=false;b(I,17)end;am=false;return end;c9=true;c3=b5.chokedcommands;b(Q,"Always on")b(S,0)b(I,17)if a(M)then ap=false;return end;if aq==0 and not bB then am=true;ap=false else ap=true end;if an[0]and an[1]then al=bu(bw(an[0],an[1]))if al~=nil then al=al-64*64;al=al<0 and 0 or al/30;al=al>62 and 62 or al end end;if al>10 then b(T,13)end;c5=1;if a(a5)==15 and bB then c6=1+a(a5)else c6=1+1+a(a5)end;ca=aw.should_lag()if not shots_fired then if ab(a6,a3[1])and ca then if c2 then c4()return end else c2=true end end;if a(a0)=="Jitter-Maximum"then if ak<2 and ab(a4,a2[1])then c8()elseif ak>2 and ab(a4,a2[2])then c8()elseif ap and ab(a4,a2[3])then c8()elseif a(V)and ab(a4,a2[4])then c8()elseif ak>2 and ca and ab(a4,a2[5])then c8()else b(P,true)c7=false;if al>10 and(a(a5)>=14 or a(a1)>=14)then b(T,1)else b(T,a(a1))end end else c7=false end;if a(a0)=="Adaptive"then b(R,"Dynamic")b(T,a(a1))b(G,false)ui.set_visible(G,false)elseif a(a0)=="Maximum"then b(R,"Maximum")b(T,a(a1))b(G,true)ui.set_visible(G,false)elseif a(a0)=="Jitter-Maximum"then b(R,"Maximum")b(G,true)ui.set_visible(G,false)end end;local function cc(cd)local ce=A()if ce==nil then return end;local cf=C(ce)if cf==nil then return end;local cg=z(cf,"m_flNextPrimaryAttack")local ch=z(ce,"m_nTickBase")end;r("run_command",cc)local function ci()k(P,H)k(Q,H)k(R,H)k(S,H)k(T,H)end;local function cj(ck)ci()if a(X)then H=false;ag=true;k(a0,true)k(a1,true)k(a6,true)if a(a0)=="Jitter-Maximum"then k(a4,true)k(a5,true)else k(a4,false)k(a5,false)end elseif a(X)then H=true;ag=false;aj()else H=true;ag=false;aj()end end;l(X,ah)r("run_command",bl)r("run_command",cb)r("paint",cj)local cl=ui.new_checkbox("AA","Fake lag","Refine Peek Lag")local cm=ui.reference("MISC","Settings","sv_maxusrcmdprocessticks")local cn=ui.reference("AA","Fake lag","Limit")local co=require("ffi")local cp={}local cq=function(az,H,ck)local cr=function(cs,ct,cu)local aS={[0]='always on',[1]='on hotkey',[2]='toggle',[3]='off hotkey'}local cv=tostring(cs)local cw=ui.get(cs)local cx=type(cw)local cy,cz=ui.get(cs)local cA=cz~=nil and cz or(cx=='boolean'and tostring(cw)or cw)cp[cv]=cp[cv]or cA;if ct then ui.set(cs,cz~=nil and aS[cu]or cu)else if cp[cv]~=nil then local cB=cp[cv]if cx=='boolean'then if cB=='true'then cB=true end;if cB=='false'then cB=false end end;ui.set(cs,cz~=nil and aS[cB]or cB)cp[cv]=nil end end end;if type(az)=='table'then for cC,cD in pairs(az)do cr(cC,cD[1],cD[2])end else cr(az,H,ck)end end;local function cE(cF,cG,cH)return{x=cF or 0,y=cG or 0,z=cH or 0}end;local function cI(bf,bg,bC)local cJ=math.sqrt(bf*bf+bg*bg+bC*bC)if cJ==0 then return 0,0,0 end;local cD=1/cJ;return bf*cD,bg*cD,bC*cD end;local function cK(cL,cM,cN,cO,cP,cQ)return cL*cO+cM*cP+cN*cQ end;local function cR(cS,cT)local cU,cV=DEG_TO_RAD*cS,DEG_TO_RAD*cT;local cW,cX,cY,cZ=math.sin(cU),math.cos(cU),math.sin(cV),math.cos(cV)return cX*cZ,cX*cY,-cW end;local function c_(d0,d1)local d2=cE(d0.x-d1.x,d0.y-d1.y,d0.z-d1.z)local d3=math.sqrt(d2.x*d2.x+d2.y*d2.y)local d4=cE(math.atan(d2.z/d3)*180/PI,math.atan(d2.y/d2.x)*180/PI,0)if d2.x>=0 then d4.y=d4.y+180.0 end;return d4 end;local function d5(d6)return globals.tickinterval()*d6 end;local function d7(d8)return 0.5+d8/globals.tickinterval()end;local function d9(bE)local da=cE(entity.get_prop(entity.get_local_player(),"m_vecVelocity"))local db=math.sqrt(da.x*da.x+da.y*da.y)local dc=cE(client.eye_position())local dd=cE(dc.x+da.x*d5(cn),dc.y+da.y*d5(cn),dc.z+da.z*d5(cn))local de=cE(entity.get_prop(bE,"m_vecVelocity"))local df=math.sqrt(de.x*de.x+de.y*de.y)local dg=cE(entity.hitbox_position(bE,3))local dh=cE(dg.x+de.x*d5(17),dg.y+de.y*d5(17),dg.z+de.z*d5(17))local di,dj=client.trace_bullet(entity.get_local_player(),dd.x,dd.y,dd.z,dh.x,dh.y,dh.z)if dj>0 then return true end;return false end;client.set_event_callback("setup_command",function(b5)local dk=false;if ui.get(cl)then b(a7,ui.get(aa))k(a7,false)k(a9,true)k(aa,true)local dl=entity.get_players(true)for aS=1,#dl do local bE=dl[aS]if d9(bE)then dk=true;k(a7,false)end end else k(a7,true)k(a9,false)end;local dm=ui.get(cm)cq({[cn]={dk,dm-(1+ui.get(a9))}})end)