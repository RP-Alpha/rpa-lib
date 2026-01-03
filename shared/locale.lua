Locales = {}

function _U(str, ...)
    if Locales[Config.Locale] then
        if Locales[Config.Locale][str] then
            return string.format(Locales[Config.Locale][str], ...)
        else
            return 'Translation [' .. Config.Locale .. '][' .. str .. '] does not exist'
        end
    else
        return 'Locale [' .. Config.Locale .. '] does not exist'
    end
end

function GetLocale(str, ...)
    return _U(str, ...)
end

exports('GetLocale', GetLocale)
