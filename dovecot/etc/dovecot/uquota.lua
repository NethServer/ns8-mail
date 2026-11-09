--
-- uquota.lua -- userdb returning the user custom quota
--
-- The custom quota value (MB) is stored by "doveadm dict set quota_clone
-- shared/<user>" (see the quota_clone/dict uquota block in dovecot.conf)
-- in a file
-- like /var/lib/dovecot/dict/uquota/first.user, containing for example
-- 1200 for about 1.2 GB quota.
--

local uquota_dir = "/var/lib/dovecot/dict/uquota/"

function auth_userdb_lookup(req)
  local user = req.user
  if user == nil or user == "" or string.find(user, "/", 1, true) then
    return dovecot.auth.USERDB_RESULT_USER_UNKNOWN, ""
  end
  local f = io.open(uquota_dir .. user, "r")
  if f == nil then
    return dovecot.auth.USERDB_RESULT_USER_UNKNOWN, ""
  end
  local mb = tonumber(f:read("*l"))
  f:close()
  if mb == nil then
    return dovecot.auth.USERDB_RESULT_USER_UNKNOWN, ""
  end
  -- As in Dovecot 2.3, the last message can exceed the limit by 10%
  return dovecot.auth.USERDB_RESULT_OK, {
    quota_storage_size = mb .. "M",
    quota_storage_grace = math.floor(mb * 1024 / 10) .. "k",
  }
end

-- This userdb adds a field to users found by other userdbs: it lists no
-- user. Without this function the whole user iteration fails.
function auth_userdb_iterate()
  return {}
end

function script_init()
  return 0
end

function script_deinit()
end
