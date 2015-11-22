#include <amxmodx>

public plugin_init() 
{ 
  register_plugin("RoundSound","1.0","PaintLancer")
  register_event("SendAudio", "t_win", "a", "2&%!MRAD_terwin")
  register_event("SendAudio", "ct_win", "a", "2&%!MRAD_ctwin")  
}

public t_win()
{
  new rand = random_num(1,10)

  client_cmd(0,"stopsound")

  switch(rand)
  {
    case 1: client_cmd(0,"spk grey/t/t1")
    case 2: client_cmd(0,"spk grey/t/t2")
    case 3: client_cmd(0,"spk grey/t/t3")
    case 4: client_cmd(0,"spk grey/t/t4")
    case 5: client_cmd(0,"spk grey/t/t5")
    case 6: client_cmd(0,"spk grey/t/t6")
    case 7: client_cmd(0,"spk grey/t/t7")
    case 8: client_cmd(0,"spk grey/t/t8")
    case 8: client_cmd(0,"spk grey/t/t9")
    case 8: client_cmd(0,"spk grey/t/t10")
   }

  return PLUGIN_HANDLED
}

public ct_win()
{
  new rand = random_num(1,10)

  client_cmd(0,"stopsound")

  switch(rand)
  {
    case 1: client_cmd(0,"spk grey/ct/ct1")
    case 2: client_cmd(0,"spk grey/ct/ct2")
    case 3: client_cmd(0,"spk grey/ct/ct3")
    case 4: client_cmd(0,"spk grey/ct/ct4")
    case 5: client_cmd(0,"spk grey/ct/ct5")
    case 6: client_cmd(0,"spk grey/ct/ct6")
    case 7: client_cmd(0,"spk grey/ct/ct7")
    case 8: client_cmd(0,"spk grey/ct/ct8")
    case 8: client_cmd(0,"spk grey/ct/ct9")
    case 8: client_cmd(0,"spk grey/ct/ct10")
   }

  return PLUGIN_HANDLED
}

public plugin_precache() 
{
  precache_sound("grey/t/t1.wav")
  precache_sound("grey/t/t2.wav")
  precache_sound("grey/t/t3.wav")
  precache_sound("grey/t/t4.wav")
  precache_sound("grey/t/t5.wav")
  precache_sound("grey/t/t6.wav")
  precache_sound("grey/t/t7.wav")
  precache_sound("grey/t/t8.wav")
  precache_sound("grey/t/t9.wav")
  precache_sound("grey/t/t10.wav")
  precache_sound("grey/ct/ct1.wav")
  precache_sound("grey/ct/ct2.wav")
  precache_sound("grey/ct/ct3.wav")
  precache_sound("grey/ct/ct4.wav")
  precache_sound("grey/ct/ct5.wav")
  precache_sound("grey/ct/ct6.wav")
  precache_sound("grey/ct/ct7.wav")
  precache_sound("grey/ct/ct8.wav")
  precache_sound("grey/ct/ct9.wav")
  precache_sound("grey/ct/ct10.wav")
  return PLUGIN_CONTINUE
}
