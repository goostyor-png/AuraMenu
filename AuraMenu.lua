__AuraFixUtil = __AuraFixUtil or {}
local Players = game:GetService("Players")
local TS = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")
local SoundService = game:GetService("SoundService")
local MPS = game:GetService("MarketplaceService")
local Lighting = game:GetService("Lighting")
local HttpService = game:GetService("HttpService")
local GuiService = game:GetService("GuiService")
local TextService = game:GetService("TextService")
local TeleportService = game:GetService("TeleportService")
local Stats = game:GetService("Stats")
local okVU, VU = pcall(game.GetService,
    game,
    "VirtualUser")

local lp = Players.LocalPlayer
local pgui = lp:WaitForChild("PlayerGui")
local genv = (getgenv and getgenv()) or _G
if genv.AuraUnload then pcall(genv.AuraUnload) end
if pgui:FindFirstChild("AuraMenu") then pgui.AuraMenu:Destroy() end
if SoundService:FindFirstChild("AuraSound") then SoundService.AuraSound:Destroy() end
for _, v in ipairs(Lighting:GetChildren()) do
    if v.Name == "AuraBlur" or v.Name == "AuraEnvBloom" or v.Name == "AuraEnvColor"
        or v.Name == "AuraEnvRays" or v.Name == "AuraEnvDOF" or v.Name == "AuraEnvAtmosphere"
        or v.Name == "AuraEnvSky" then
        pcall(function() v:Destroy() end)
    end
end
local oldAuraClouds = workspace:FindFirstChildOfClass("Terrain") and workspace.Terrain:FindFirstChild("AuraEnvClouds")
if oldAuraClouds then pcall(function() oldAuraClouds:Destroy() end) end
local oldAuraAmbient = workspace:FindFirstChild("AuraAmbientFX")
if oldAuraAmbient then pcall(function() oldAuraAmbient:Destroy() end) end

local WIN_W, WIN_H, TOP, SB = 420, 270, 36, 96
local EASE, DIR = Enum.EasingStyle, Enum.EasingDirection
local WHITE = Color3.new(1,
    1,
    1)
local C = {
	bg = Color3.fromRGB(13,
	    13,
	    20),
	    bar = Color3.fromRGB(19,
	    19,
	    28),
	    card = Color3.fromRGB(25,
	    25,
	    37),
	    card2 = Color3.fromRGB(38,
	    38,
	    55),
	    card3 = Color3.fromRGB(31,
	    31,
	    46),
	    border = Color3.fromRGB(73,
	    73,
	    104),
	    text = Color3.fromRGB(238,
	    238,
	    248),
	    sub = Color3.fromRGB(140,
	    140,
	    168),
	    off = Color3.fromRGB(52,
	    52,
	    72),
	    bad = Color3.fromRGB(255,
	    95,
	    105),
	    good = Color3.fromRGB(80,
	    225,
	    140),
	    warn = Color3.fromRGB(255,
	    190,
	    80),
	    softBlue = Color3.fromRGB(95,
	    180,
	    255),
}
local accent = Color3.fromRGB(130,
    100,
    255)
local reg, conns, trReg, ctl = {}, {}, {}, {}
local rainbow, hue = false, 0
local lang = "Русский"
local cfg = {}

local EN = {
	["Музыка"] = "Music",
	    ["Эффекты"] = "Effects",
	    ["Визуал"] = "Visuals",
	    ["Разное"] = "Misc",
	    ["Настройки"] = "Settings",
	    ["ПЛЕЕР"] = "PLAYER",
	    ["Вставьте ID песни"] = "Paste song ID",
	    ["Играть"] = "Play",
	    ["Пауза"] = "Pause",
	    ["Стоп"] = "Stop",
	    ["-10с"] = "-10s",
	    ["+10с"] = "+10s",
	    ["Трек"] = "Track",
	    ["Повтор трека"] = "Repeat track",
	    ["СКОРОСТЬ И ТОНАЛЬНОСТЬ"] = "SPEED & PITCH",
	    ["Скорость"] = "Speed",
	    ["Менять тон со скоростью"] = "Pitch follows speed",
	    ["Тональность"] = "Pitch",
	    ["пт"] = "st",
	    ["ГРОМКОСТЬ"] = "VOLUME",
	    ["Усиление"] = "Gain",
	    ["Сбросить всё"] = "Reset all",
	    ["ПРЕСЕТЫ"] = "PRESETS",
	    ["Сброс"] = "Reset",
	    ["ЭКВАЛАЙЗЕР"] = "EQUALIZER",
	    ["Низкие"] = "Low",
	    ["Средние"] = "Mid",
	    ["Высокие"] = "High",
	    ["ПРОСТРАНСТВО"] = "SPACE",
	    ["Реверберация"] = "Reverb",
	    ["Эхо"] = "Echo",
	    ["Клуб"] = "Club",
	    ["Кино"] = "Cinematic",
	    ["Радио"] = "Radio",
	    ["Тёплый"] = "Warm",
	    ["Яркий звук"] = "Bright Sound",
	    ["Больше пространства"] = "Wide Space",
	    ["Эхо-задержка"] = "Echo delay",
	    ["Обратная связь эха"] = "Echo feedback",
	    ["Длина реверберации"] = "Reverb decay",
	    ["Сброс аудио"] = "Reset audio",
	    ["ВЫРАЗИТЕЛЬНОСТЬ ЗВУКА"] = "SOUND SHAPING",
	    ["НАСТРОЙКИ ПРОСТРАНСТВА"] = "SPACE SETTINGS",
	    ["ОТОБРАЖЕНИЕ"] = "DISPLAY",
	    ["Подсветка игроков"] = "Player highlight",
	    ["Скелет"] = "Skeleton",
	    ["Имена"] = "Names",
	    ["Дистанция"] = "Distance",
	    ["Дальность"] = "Range",
	    ["Стиль"] = "Style",
	    ["Контур"] = "Outline",
	    ["Заливка"] = "Fill",
	    ["Градиент"] = "Gradient",
	    ["ст."] = "studs",
	    ["ОБЩЕЕ"] = "GENERAL",
	    ["Анти-АФК"] = "Anti-AFK",
	    ["Показывать FPS"] = "Show FPS",
	    ["Авто-перезаход"] = "Auto rejoin",
	    ["Поле зрения"] = "Field of view",
	    ["Язык"] = "Language",
	    ["Сохранить конфиг"] = "Save config",
	    ["Загрузить конфиг"] = "Load config",
	    ["ЦВЕТ АКЦЕНТА"] = "ACCENT COLOR",
	    ["Оттенок"] = "Hue",
	    ["ОКНО"] = "WINDOW",
	    ["Прозрачность"] = "Transparency",
	    ["Размер меню"] = "Menu size",
	    ["Размытие фона"] = "Background blur",
	    ["Сбросить позицию"] = "Reset position",
	    ["Выгрузить меню"] = "Unload menu",
	    ["Ничего не играет"] = "Nothing playing",
	    ["Введите ID и нажмите «Играть»"] = "Enter an ID and press Play",
	    ["Введите числовой ID"] = "Enter a numeric ID",
	    ["Загрузка..."] = "Loading...",
	    ["Играет"] = "Playing",
	    ["На паузе"] = "Paused",
	    ["Остановлено"] = "Stopped",
	    ["Трек закончился"] = "Track ended",
	    ["Ошибка"] = "Error",
	    ["Не загрузилось: ID закрыт или неверный"] = "Failed to load: ID is private or invalid",
	    ["Трек загружен"] = "Track loaded",
	    ["Не удалось загрузить ID"] = "Could not load ID",
	    ["Пресет: "] = "Preset: ",
	    ["Всё сброшено"] = "Everything reset",
	    ["Акцент изменён"] = "Accent changed",
	    ["Радужный режим"] = "Rainbow mode",
	    ["Радуга выключена"] = "Rainbow off",
	    ["Конфиг сохранён"] = "Config saved",
	    ["Сохранение недоступно"] = "Saving unavailable",
	    ["Конфиг загружен"] = "Config loaded",
	    ["Конфиг не найден"] = "Config not found",
	    ["Переподключение..."] = "Reconnecting...",
	    ["AURA загружено"] = "AURA loaded",
	    ["Найти"] = "Search",
	    ["Поиск..."] = "Searching...",
	    ["Введите хотя бы 2 символа"] = "Enter at least 2 characters",
	    ["Ничего не найдено"] = "No results found",
	    ["Поиск недоступен в этой среде"] = "Search is unavailable here; try an audio ID",
	    ["Пуск / пауза"] = "Play / Pause",
	    ["Ночной"] = "Night",
	    ["Замедленный"] = "Slowed",
	    ["Бас"] = "Bass",
	    ["Золотой час"] = "Golden Hour",
	    ["Ужас"] = "Horror",
	    ["Под водой"] = "Underwater",
	    ["Научная фантастика"] = "Sci-Fi",
	    ["Северное сияние"] = "Aurora",
	    ["Отключить эффекты"] = "Disable effects",
	    ["ВИЗУАЛЬНЫЕ ЭФФЕКТЫ"] = "VISUAL EFFECTS",
	    ["Мягкое свечение и цвет"] = "Soft bloom & color",
	    ["Интенсивность эффекта"] = "Effect intensity",
	    ["ПРЕСЕТЫ ОКРУЖЕНИЯ"] = "ENVIRONMENT PRESETS",
	    ["Толщина скелета"] = "Skeleton thickness",
	    ["Эффект сброшен"] = "Effect reset",
	    ["Активен эффект: "] = "Active effect: ",
	    ["ОЧЕРЕДЬ"] = "QUEUE",
	    ["Очередь пуста"] = "Queue is empty",
	    ["Очередь"] = "Queue",
	    ["В очереди"] = "In queue",
	    ["Очистить очередь"] = "Clear queue",
	    ["Добавить в очередь"] = "Add to queue",
	    ["Играть сейчас"] = "Play now",
	    ["Удалить"] = "Remove",
	    ["Автор неизвестен"] = "Unknown artist",
	    ["ВИЗУАЛЬНЫЙ ESP"] = "VISUAL ESP",
	    ["Рамка игрока"] = "Player box",
	    ["Полоса здоровья"] = "Health bar",
	    ["Трассеры"] = "Tracers",
	    ["Проверка команды"] = "Team check",
	    ["Здоровье в имени"] = "Health in label",
	    ["ЦВЕТ И ПЛАВНОСТЬ"] = "COLOR & SMOOTHNESS",
	    ["Плавность анимаций"] = "Animation smoothness",
	    ["Яркость ESP"] = "ESP brightness",
	    ["Размер подписей"] = "Label size",
	    ["Толщина рамки"] = "Box thickness",
	    ["ИНФОРМАЦИЯ О ПЛЕЕРЕ"] = "PLAYER INFO",
	    ["Треков в очереди"] = "Tracks queued",
	    ["Очередь обновлена"] = "Queue updated",
	    ["Добавлено в очередь"] = "Added to queue",
	    ["Авто-скрытие после выбора"] = "Auto-hide after starting playback",
	    ["Скорость анимаций"] = "Animation speed",
	    ["Сбросить конфиг"] = "Reset settings",
	    ["Всё включить"] = "Enable all",
	    ["Всё скрыть"] = "Hide all",
	    ["Уже в очереди"] = "Already queued",
	    ["Список очищен"] = "List cleared",
	    ["ОКРУЖЕНИЕ"] = "ENVIRONMENT",
	    ["Мягкое свечение"] = "Soft bloom",
	    ["Сила свечения"] = "Bloom strength",
	    ["Цветовой стиль"] = "Color style",
	    ["Солнечные лучи"] = "Sun rays",
	    ["Кино"] = "Cinematic",
	    ["Яркий"] = "Vivid",
	    ["Микшер"] = "Mixer",
	    ["Быстрые настройки"] = "Quick controls",
	    ["Тихо"] = "Quiet",
	    ["Обычный"] = "Normal",
	    ["Громко"] = "Loud",
	    ["Максимум"] = "Maximum",
	    ["Сменить трек"] = "Change track",
	    ["Отмена"] = "Cancel",
	    ["Включено"] = "Enabled",
	    ["Выключено"] = "Disabled",
	    ["БЫСТРЫЕ НАСТРОЙКИ"] = "QUICK SETTINGS",
	    ["ВИЗУАЛИЗАТОР"] = "VISUALIZER",
	    ["Пульсация акцента"] = "Accent pulse",
	    ["Авто-очередь"] = "Auto queue",
	    ["Исходный вид"] = "Original look",
	    ["Кинематограф"] = "Cinematic",
	    ["Неоновые сумерки"] = "Neon Dusk",
	    ["Лавандовый сон"] = "Lavender Dream",
	    ["Изумрудный туман"] = "Emerald Mist",
	    ["Кристальный лёд"] = "Crystal Ice",
	    ["Призматическая аврора"] = "Prismatic Aurora",
	    ["Эффекты окружения"] = "ENVIRONMENT EFFECTS",
	    ["Плавные переходы"] = "Smooth transitions",
	    ["Эффекты отключены"] = "Effects disabled",
	    ["Поиск недоступен в этой среде"] = "Search is unavailable in this client; enter an audio ID",
		    ["Помощь"] = "Help",
	    ["ESP"] = "ESP",
	    ["Напиши вопрос..."] = "Ask a question...",
	    ["Отправить"] = "Send",
		    ["Локально + веб-поиск"] = "Local + web lookup",
    ["Код / Luau"] = "Code / Luau",
    ["Помощь"] = "Help",
	    ["Спросить о функции"] = "Ask about a feature",
	    ["Примеры вопросов"] = "Example questions",
	    ["Очистить чат"] = "Clear chat",
	    ["Свернуть"] = "Minimize",
	    ["Закрыть"] = "Close",
}


-- Spanish localization: any legacy key not listed here falls back to English,
-- so the interface never abruptly switches back to Russian while Español is active.
local ES = {
    ["Музыка"]="Música",
        ["Эффекты"]="Efectos",
        ["Визуал"]="Visuales",
        ["Разное"]="Varios",
        ["Настройки"]="Ajustes",
        ["ПЛЕЕР"]="REPRODUCTOR",
        ["Вставьте ID песни"]="Introduce el ID de la canción",
        ["Играть"]="Reproducir",
        ["Пауза"]="Pausar",
        ["Стоп"]="Detener",
        ["-10с"]="-10 s",
        ["+10с"]="+10 s",
        ["Трек"]="Pista",
        ["Повтор трека"]="Repetir pista",
        ["СКОРОСТЬ И ТОНАЛЬНОСТЬ"]="VELOCIDAD Y TONO",
        ["Скорость"]="Velocidad",
        ["Менять тон со скоростью"]="Cambiar tono con la velocidad",
        ["Тональность"]="Tono",
        ["пт"]="st",
        ["ГРОМКОСТЬ"]="VOLUMEN",
        ["Усиление"]="Ganancia",
        ["Сбросить всё"]="Restablecer todo",
        ["ПРЕСЕТЫ"]="PREAJUSTES",
        ["Сброс"]="Restablecer",
        ["ЭКВАЛАЙЗЕР"]="ECUALIZADOR",
        ["Низкие"]="Graves",
        ["Средние"]="Medios",
        ["Высокие"]="Agudos",
        ["ПРОСТРАНСТВО"]="ESPACIO",
        ["Реверберация"]="Reverberación",
        ["Эхо"]="Eco",
        ["Клуб"]="Club",
        ["Кино"]="Cine",
        ["Радио"]="Radio",
        ["Тёплый"]="Cálido",
        ["Яркий звук"]="Sonido brillante",
        ["Больше пространства"]="Más amplitud",
        ["Эхо-задержка"]="Retardo del eco",
        ["Обратная связь эха"]="Realimentación del eco",
        ["Длина реверберации"]="Duración de reverberación",
        ["Сброс аудио"]="Restablecer audio",
        ["ВЫРАЗИТЕЛЬНОСТЬ ЗВУКА"]="MOLDEADO DEL SONIDO",
        ["НАСТРОЙКИ ПРОСТРАНСТВА"]="AJUSTES ESPACIALES",
        ["ОТОБРАЖЕНИЕ"]="VISUALIZACIÓN",
        ["Подсветка игроков"]="Resaltar jugadores",
        ["Скелет"]="Esqueleto",
        ["Имена"]="Nombres",
        ["Дистанция"]="Distancia",
        ["Дальность"]="Alcance",
        ["Стиль"]="Estilo",
        ["Контур"]="Contorno",
        ["Заливка"]="Relleno",
        ["Градиент"]="Degradado",
        ["ст."]="studs",
        ["ОБЩЕЕ"]="GENERAL",
        ["Анти-АФК"]="Anti-AFK",
        ["Показывать FPS"]="Mostrar FPS",
        ["Авто-перезаход"]="Reconexión automática",
        ["Поле зрения"]="Campo de visión",
        ["Язык"]="Idioma",
        ["Сохранить конфиг"]="Guardar configuración",
        ["Загрузить конфиг"]="Cargar configuración",
        ["ЦВЕТ АКЦЕНТА"]="COLOR DE ACENTO",
        ["Оттенок"]="Tono de color",
        ["ОКНО"]="VENTANA",
        ["Прозрачность"]="Transparencia",
        ["Размер меню"]="Tamaño del menú",
        ["Размытие фона"]="Desenfoque del fondo",
        ["Сбросить позицию"]="Restablecer posición",
        ["Выгрузить меню"]="Cerrar menú",
        ["Ничего не играет"]="No se está reproduciendo nada",
        ["Введите ID и нажмите «Играть»"]="Introduce un ID y pulsa Reproducir",
        ["Введите числовой ID"]="Introduce un ID numérico",
        ["Загрузка..."]="Cargando...",
        ["Играет"]="Reproduciendo",
        ["На паузе"]="En pausa",
        ["Остановлено"]="Detenido",
        ["Трек закончился"]="La pista terminó",
        ["Ошибка"]="Error",
        ["Не загрузилось: ID закрыт или неверный"]="No se pudo cargar: ID privado o no válido",
        ["Трек загружен"]="Pista cargada",
        ["Не удалось загрузить ID"]="No se pudo cargar el ID",
        ["Пресет: "]="Preajuste: ",
        ["Всё сброшено"]="Todo restablecido",
        ["Акцент изменён"]="Acento cambiado",
        ["Радужный режим"]="Modo arcoíris",
        ["Радуга выключена"]="Arcoíris desactivado",
        ["Конфиг сохранён"]="Configuración guardada",
        ["Сохранение недоступно"]="Guardado no disponible",
        ["Конфиг загружен"]="Configuración cargada",
        ["Конфиг не найден"]="No se encontró la configuración",
        ["Переподключение..."]="Reconectando...",
        ["AURA загружено"]="AURA cargado",
        ["Найти"]="Buscar",
        ["Поиск..."]="Buscando...",
        ["Введите хотя бы 2 символа"]="Introduce al menos 2 caracteres",
        ["Ничего не найдено"]="No se encontraron resultados",
        ["Поиск недоступен в этой среде"]="La búsqueda no está disponible aquí; introduce un ID de audio",
        ["Пуск / пауза"]="Reproducir / pausar",
        ["Ночной"]="Nocturno",
        ["Замедленный"]="Ralentizado",
        ["Бас"]="Graves",
        ["Золотой час"]="Hora dorada",
        ["Ужас"]="Terror",
        ["Под водой"]="Bajo el agua",
        ["Научная фантастика"]="Ciencia ficción",
        ["Северное сияние"]="Aurora boreal",
        ["Отключить эффекты"]="Desactivar efectos",
        ["ВИЗУАЛЬНЫЕ ЭФФЕКТЫ"]="EFECTOS VISUALES",
        ["Мягкое свечение и цвет"]="Brillo suave y color",
        ["Интенсивность эффекта"]="Intensidad del efecto",
        ["ПРЕСЕТЫ ОКРУЖЕНИЯ"]="PREAJUSTES DEL ENTORNO",
        ["Толщина скелета"]="Grosor del esqueleto",
        ["Эффект сброшен"]="Efecto restablecido",
        ["Активен эффект: "]="Efecto activo: ",
        ["ОЧЕРЕДЬ"]="COLA",
        ["Очередь пуста"]="La cola está vacía",
        ["Очередь"]="Cola",
        ["В очереди"]="En la cola",
        ["Очистить очередь"]="Vaciar cola",
        ["Добавить в очередь"]="Añadir a la cola",
        ["Играть сейчас"]="Reproducir ahora",
        ["Удалить"]="Eliminar",
        ["Автор неизвестен"]="Artista desconocido",
        ["ВИЗУАЛЬНЫЙ ESP"]="ESP VISUAL",
        ["Рамка игрока"]="Caja del jugador",
        ["Полоса здоровья"]="Barra de salud",
        ["Трассеры"]="Trazadores",
        ["Проверка команды"]="Comprobar equipo",
        ["Здоровье в имени"]="Salud en la etiqueta",
        ["ЦВЕТ И ПЛАВНОСТЬ"]="COLOR Y SUAVIDAD",
        ["Плавность анимаций"]="Suavidad de animación",
        ["Яркость ESP"]="Brillo del ESP",
        ["Размер подписей"]="Tamaño de etiquetas",
        ["Толщина рамки"]="Grosor de caja",
        ["ИНФОРМАЦИЯ О ПЛЕЕРЕ"]="INFORMACIÓN DEL JUGADOR",
        ["Треков в очереди"]="Pistas en la cola",
        ["Очередь обновлена"]="Cola actualizada",
        ["Добавлено в очередь"]="Añadido a la cola",
        ["Авто-скрытие после выбора"]="Ocultar automáticamente al iniciar",
        ["Скорость анимаций"]="Velocidad de animación",
        ["Сбросить конфиг"]="Restablecer ajustes",
        ["Всё включить"]="Activar todo",
        ["Всё скрыть"]="Ocultar todo",
        ["Уже в очереди"]="Ya está en la cola",
        ["Список очищен"]="Lista vaciada",
        ["ОКРУЖЕНИЕ"]="ENTORNO",
        ["Мягкое свечение"]="Brillo suave",
        ["Сила свечения"]="Intensidad del brillo",
        ["Цветовой стиль"]="Estilo de color",
        ["Солнечные лучи"]="Rayos solares",
        ["Яркий"]="Intenso",
        ["Микшер"]="Mezclador",
        ["Быстрые настройки"]="Controles rápidos",
        ["Тихо"]="Bajo",
        ["Обычный"]="Normal",
        ["Громко"]="Alto",
        ["Максимум"]="Máximo",
        ["Сменить трек"]="Cambiar pista",
        ["Отмена"]="Cancelar",
        ["Включено"]="Activado",
        ["Выключено"]="Desactivado",
        ["БЫСТРЫЕ НАСТРОЙКИ"]="AJUSTES RÁPIDOS",
        ["ВИЗУАЛИЗАТОР"]="VISUALIZADOR",
        ["Пульсация акцента"]="Pulso del acento",
        ["Авто-очередь"]="Cola automática",
        ["Исходный вид"]="Aspecto original",
        ["Кинематограф"]="Cinematográfico",
        ["Неоновые сумерки"]="Crepúsculo neón",
        ["Лавандовый сон"]="Sueño lavanda",
        ["Изумрудный туман"]="Niebla esmeralda",
        ["Кристальный лёд"]="Hielo cristalino",
        ["Призматическая аврора"]="Aurora prismática",
        ["Эффекты окружения"]="EFECTOS DEL ENTORNO",
        ["Плавные переходы"]="Transiciones suaves",
        ["Эффекты отключены"]="Efectos desactivados",
        ["Сила реверберации"]="Intensidad de reverberación",
        ["Мягкий"]="Suave",
        ["Пики"]="Picos",
        ["Спектр"]="Espectro",
        ["Помощь"]="Ayuda",
        ["ESP"]="ESP",
        ["Напиши вопрос..."]="Escribe una pregunta...",
        ["Отправить"]="Enviar",
        ["Локально + веб-поиск"]="Modo local + búsqueda web",
        ["Код / Luau"]="Código / Luau",
        ["Спросить о функции"]="Pregunta por una función",
        ["Примеры вопросов"]="Ejemplos de preguntas",
        ["Очистить чат"]="Borrar chat",
        ["Свернуть"]="Minimizar",
        ["Закрыть"]="Cerrar",
}

do
    EN["Игрок"] = "Player"
    EN["RTX"] = "RTX"
    EN["RTX РЕЖИМЫ"] = "RTX MODES"
    EN["Режим RTX"] = "RTX mode"
    EN["Выкл"] = "Off"
    EN["Неон"] = "Neon"
    EN["Закат"] = "Sunset"
    EN["Кино RTX"] = "Cinema RTX"
    EN["Неон RTX"] = "Neon RTX"
    EN["Закат RTX"] = "Sunset RTX"
    EN["RTX выключен"] = "RTX off"
    EN["Сила RTX"] = "RTX strength"
    EN["ДЕТАЛИ КАРТИНКИ"] = "IMAGE DETAILS"
    EN["Кинолента (чёрные полосы)"] = "Letterbox bars"
    EN["Блики от солнца"] = "Sun lens flares"
    EN["Покачивание камеры"] = "Camera sway"
    EN["Оверлей эффектов"] = "Effects overlay"
    EN["Отражения материалов"] = "Material reflections"
    EN["О РЕЖИМАХ"] = "ABOUT MODES"
    EN["Кино: автофокус, плёночное зерно, анаморфные блики."] = "Cinema: autofocus, film grain, anamorphic flares."
    EN["Неон: ночь, дождь, мокрые отражения, молнии."] = "Neon: night, rain, wet reflections, lightning."
    EN["Закат: золотой час, лучи, облака, боке."] = "Sunset: golden hour, god rays, clouds, bokeh."
    EN["ПОЛЁТ"] = "FLIGHT"
    EN["Полёт (F)"] = "Fly (F)"
    EN["Скорость полёта"] = "Fly speed"
    EN["Плавность разгона"] = "Acceleration smoothness"
    EN["ДВИЖЕНИЕ"] = "MOVEMENT"
    EN["AURA.ME"] = "AURA.ME"
    EN["Орбы с лучами"] = "Linked orbs"
    EN["Нимб"] = "Halo"
    EN["Магический круг"] = "Magic circle"
    EN["Крылья света"] = "Light wings"
    EN["Частицы и свечение"] = "Particles & glow"
    EN["Следы рук и ног"] = "Limb trails"
    EN["Рябь от шагов"] = "Step ripples"
    EN["Интенсивность"] = "Intensity"
    EN["Скорость эффектов"] = "Effect speed"
    EN["Количество орбов"] = "Orb count"
    EN["Цвет эффектов"] = "Effect color"
    EN["Акцент"] = "Accent"
    EN["Градиент"] = "Gradient"
    EN["Радуга"] = "Rainbow"
    EN["Аккуратный"] = "Careful"
    EN["Плавный"] = "Smooth"
    EN["Обычный"] = "Normal"
    EN["Голова"] = "Head"
    EN["Тело"] = "Body"
    EN["Рука"] = "Arm"
    EN["Ноги"] = "Legs"
    EN["Рандом"] = "Random"
    EN["Скорость наводки"] = "Aim speed"
    EN["Куда попадать"] = "Hit target"
    EN["Радиус FOV"] = "FOV radius"
    EN["Сила помощи"] = "Assist strength"
    EN["Куда помогать"] = "Assist target"
    EN["Радиус помощи"] = "Assist radius"
    EN["ПРИЦЕЛ"] = "AIMING"
    EN["Дальность цели"] = "Target range"
    EN["Проверка стен"] = "Wall check"
    EN["Показывать круг FOV"] = "Show FOV circle"
    EN["Персонаж не найден"] = "Character not found"
    EN["Aura.Me включена"] = "Aura.Me enabled"
    EN["Уголки рамки"] = "Corner box"
    EN["Стрелки за экраном"] = "Off-screen arrows"
    EN["Точка головы"] = "Head ring"
    EN["Проверка видимости"] = "Visibility check"
    EN["Aimbot (B)"] = "Aimbot (B)"
    EN["Aim Assist (V)"] = "Aim Assist (V)"
    EN["Aura.Me (H)"] = "Aura.Me (H)"
    EN["Noclip (N)"] = "Noclip (N)"
    EN["Быстрые кнопки"] = "Quick buttons"
    EN["Полёт"] = "Fly"
    EN["Мягкий"] = "Soft"
    EN["Пики"] = "Peaks"
    EN["Спектр"] = "Spectrum"
    EN["Сила реверберации"] = "Reverb intensity"
    EN["ПОДСКАЗКИ УПРАВЛЕНИЯ"] = "CONTROLS"
    EN["ПК: F, N, B, V, H, Пробел, Ctrl"] = "PC: F, N, B, V, H, Space, Ctrl"
    EN["Телефон: кнопки слева и ▲ ▼ в полёте"] = "Phone: left buttons and ▲ ▼ while flying"
    EN["БИНДЫ"] = "KEYBINDS"
    EN["Следующий режим RTX"] = "Next RTX mode"
    EN["ESP вкл/выкл"] = "ESP on/off"
    EN["Следующая цель попадания"] = "Next hit target"
    EN["Полёт вверх"] = "Fly up"
    EN["Полёт вниз"] = "Fly down"
    EN["Aimbot по удержанию"] = "Aimbot hold key"
    EN["Открыть/закрыть меню"] = "Open/close menu"
    EN["Нет"] = "None"
    EN["Нажмите клавишу..."] = "Press a key..."
    EN["Нажми на кнопку, затем на клавишу. Backspace снимает бинд, Esc отменяет."] = "Click a button, then press a key. Backspace clears the bind, Esc cancels."
    EN["Сбросить бинды"] = "Reset binds"
    EN["Бинды сброшены"] = "Binds reset"
    EN["ПК: клавиши в Настройки → Бинды"] = "PC: keys in Settings → Keybinds"
    EN["Молнии между орбами"] = "Orb lightning"
    EN["Столб света"] = "Light pillar"
    EN["Двойная спираль"] = "Double helix"
    EN["Остаточные образы"] = "Afterimages"
    EN["Волны импульса"] = "Pulse waves"
    EN["Реакция на музыку"] = "Music reaction"
    EN["Aimbot по зажатой ПКМ"] = "Aimbot on right mouse hold (PC)"
    ES["БИНДЫ"] = "ATAJOS"
    ES["Следующий режим RTX"] = "Siguiente modo RTX"
    ES["ESP вкл/выкл"] = "ESP activar/desactivar"
    ES["Следующая цель попадания"] = "Siguiente zona de impacto"
    ES["Полёт вверх"] = "Volar arriba"
    ES["Полёт вниз"] = "Volar abajo"
    ES["Aimbot по удержанию"] = "Tecla de mantener Aimbot"
    ES["Открыть/закрыть меню"] = "Abrir/cerrar menú"
    ES["Нет"] = "Ninguno"
    ES["Нажмите клавишу..."] = "Pulsa una tecla..."
    ES["Нажми на кнопку, затем на клавишу. Backspace снимает бинд, Esc отменяет."] = "Pulsa un botón y luego una tecla. Retroceso borra el atajo, Esc cancela."
    ES["Сбросить бинды"] = "Restablecer atajos"
    ES["Бинды сброшены"] = "Atajos restablecidos"
    ES["ПК: клавиши в Настройки → Бинды"] = "PC: teclas en Ajustes → Atajos"
    ES["Молнии между орбами"] = "Rayos entre orbes"
    ES["Столб света"] = "Pilar de luz"
    ES["Двойная спираль"] = "Doble hélice"
    ES["Остаточные образы"] = "Imágenes residuales"
    ES["Волны импульса"] = "Ondas de pulso"
    ES["Реакция на музыку"] = "Reacción a la música"
    ES["ПОДСКАЗКИ УПРАВЛЕНИЯ"] = "CONTROLES"
    ES["ПК: F, N, B, V, H, Пробел, Ctrl"] = "PC: F, N, B, V, H, Espacio, Ctrl"
    ES["Телефон: кнопки слева и ▲ ▼ в полёте"] = "Móvil: botones a la izquierda y ▲ ▼ al volar"
    ES["Aimbot по зажатой ПКМ"] = "Aimbot con clic derecho mantenido (PC)"
    ES["Aura.Me включена"] = "Aura.Me activada"
    ES["RTX РЕЖИМЫ"] = "MODOS RTX"
    ES["RTX выключен"] = "RTX desactivado"
    ES["Аккуратный"] = "Cuidadoso"
    ES["Акцент"] = "Acento"
    ES["Блики от солнца"] = "Destellos del sol"
    ES["Выкл"] = "Apag."
    ES["Голова"] = "Cabeza"
    ES["ДВИЖЕНИЕ"] = "MOVIMIENTO"
    ES["ДЕТАЛИ КАРТИНКИ"] = "DETALLES DE IMAGEN"
    ES["Дальность цели"] = "Alcance del objetivo"
    ES["Закат"] = "Atardecer"
    ES["Закат RTX"] = "RTX Atardecer"
    ES["Закат: золотой час, лучи, облака, боке."] = "Atardecer: hora dorada, rayos, nubes, bokeh."
    ES["Игрок"] = "Jugador"
    ES["Интенсивность"] = "Intensidad"
    ES["Кино RTX"] = "RTX Cine"
    ES["Кино: автофокус, плёночное зерно, анаморфные блики."] = "Cine: autoenfoque, grano de película, destellos anamórficos."
    ES["Кинолента (чёрные полосы)"] = "Bandas de cine (negras)"
    ES["Количество орбов"] = "Número de orbes"
    ES["Крылья света"] = "Alas de luz"
    ES["Куда помогать"] = "Dónde ayudar"
    ES["Куда попадать"] = "Dónde apuntar"
    ES["Магический круг"] = "Círculo mágico"
    ES["Неон"] = "Neón"
    ES["Неон RTX"] = "RTX Neón"
    ES["Неон: ночь, дождь, мокрые отражения, молнии."] = "Neón: noche, lluvia, reflejos mojados, rayos."
    ES["Нимб"] = "Halo"
    ES["Ноги"] = "Piernas"
    ES["О РЕЖИМАХ"] = "SOBRE LOS MODOS"
    ES["Оверлей эффектов"] = "Capa de efectos"
    ES["Орбы с лучами"] = "Orbes con rayos"
    ES["Отражения материалов"] = "Reflejos de materiales"
    ES["ПОЛЁТ"] = "VUELO"
    ES["ПРИЦЕЛ"] = "PUNTERÍA"
    ES["Персонаж не найден"] = "Personaje no encontrado"
    ES["Плавность разгона"] = "Suavidad de aceleración"
    ES["Плавный"] = "Suave"
    ES["Показывать круг FOV"] = "Mostrar círculo FOV"
    ES["Покачивание камеры"] = "Balanceo de cámara"
    ES["Полёт (F)"] = "Volar (F)"
    ES["Проверка видимости"] = "Comprobar visibilidad"
    ES["Проверка стен"] = "Comprobar paredes"
    ES["Радиус FOV"] = "Radio FOV"
    ES["Радиус помощи"] = "Radio de ayuda"
    ES["Радуга"] = "Arcoíris"
    ES["Рандом"] = "Aleatorio"
    ES["Режим RTX"] = "Modo RTX"
    ES["Рука"] = "Brazo"
    ES["Рябь от шагов"] = "Ondas al caminar"
    ES["Сила RTX"] = "Fuerza RTX"
    ES["Сила помощи"] = "Fuerza de ayuda"
    ES["Скорость наводки"] = "Velocidad de apuntado"
    ES["Скорость полёта"] = "Velocidad de vuelo"
    ES["Скорость эффектов"] = "Velocidad de efectos"
    ES["Следы рук и ног"] = "Estelas de manos y pies"
    ES["Стрелки за экраном"] = "Flechas fuera de pantalla"
    ES["Тело"] = "Cuerpo"
    ES["Точка головы"] = "Anillo de cabeza"
    ES["Уголки рамки"] = "Esquinas del cuadro"
    ES["Цвет эффектов"] = "Color de efectos"
    ES["Частицы и свечение"] = "Partículas y brillo"
    ES["Градиент"] = "Degradado"
    ES["Обычный"] = "Normal"
    ES["RTX"] = "RTX"
    ES["AURA.ME"] = "AURA.ME"
    ES["Aimbot (B)"] = "Aimbot (B)"
    ES["Aim Assist (V)"] = "Aim Assist (V)"
    ES["Aura.Me (H)"] = "Aura.Me (H)"
    ES["Noclip (N)"] = "Noclip (N)"
    ES["Быстрые кнопки"] = "Botones rápidos"
    ES["Полёт"] = "Vuelo"
    ES["Сила реверберации"] = "Intensidad de reverberación"
    -- ===== new strings (tabs / combat / aura / RTX polish) =====
    EN["Бой"] = "Combat"; ES["Бой"] = "Combate"
    EN["Aura.Me"] = "Aura.Me"; ES["Aura.Me"] = "Aura.Me"
    EN["БЫСТРЫЙ ДОСТУП"] = "QUICK ACCESS"; ES["БЫСТРЫЙ ДОСТУП"] = "ACCESO RÁPIDO"
    EN["Скорость вверх/вниз"] = "Vertical speed"; ES["Скорость вверх/вниз"] = "Velocidad vertical"
    EN["Наклон тела в полёте"] = "Body tilt while flying"; ES["Наклон тела в полёте"] = "Inclinación al volar"
    EN["ЦЕЛЬ"] = "TARGET"; ES["ЦЕЛЬ"] = "OBJETIVO"
    EN["УПРАВЛЕНИЕ"] = "CONTROLS"; ES["УПРАВЛЕНИЕ"] = "CONTROLES"
    EN["Показывать метку цели"] = "Show target label"; ES["Показывать метку цели"] = "Mostrar etiqueta del objetivo"
    EN["Клавиши: Настройки → Бинды"] = "Keys: Settings → Binds"; ES["Клавиши: Настройки → Бинды"] = "Teclas: Ajustes → Binds"
    EN["ЭЛЕМЕНТЫ"] = "ELEMENTS"; ES["ЭЛЕМЕНТЫ"] = "ELEMENTOS"
    EN["ДЕТАЛИ"] = "DETAILS"; ES["ДЕТАЛИ"] = "DETALLES"
    EN["КАЧЕСТВО КАРТИНКИ"] = "IMAGE QUALITY"; ES["КАЧЕСТВО КАРТИНКИ"] = "CALIDAD DE IMAGEN"
    EN["Future-освещение (ПК)"] = "Future lighting (PC)"; ES["Future-освещение (ПК)"] = "Iluminación Future (PC)"
    EN["Мягкие тени и небо"] = "Soft shadows & sky"; ES["Мягкие тени и небо"] = "Sombras suaves y cielo"
    EN["Свечение (Bloom)"] = "Glow (Bloom)"; ES["Свечение (Bloom)"] = "Brillo (Bloom)"
    EN["Цветокоррекция"] = "Color grading"; ES["Цветокоррекция"] = "Corrección de color"
    EN["Объёмная дымка"] = "Volumetric haze"; ES["Объёмная дымка"] = "Neblina volumétrica"
    EN["Глубина резкости"] = "Depth of field"; ES["Глубина резкости"] = "Profundidad de campo"
end

local function T(s)
    if lang == "English" then return EN[s] or s end
    if lang == "Español" then return ES[s] or EN[s] or s end
    return s
end

local function bind(o, s, prop)
	prop = prop or "Text"
	o[prop] = T(s)
	trReg[#trReg + 1] = function() o[prop] = T(s) end
end

local function setLang(i)
	lang = i == 2 and "English" or (i == 3 and "Español" or "Русский")
	cfg.lang = i
    pcall(__AuraFixUtil.saveCfg)
	for _, f in ipairs(trReg) do f() end
	for _, o in pairs(ctl) do if o.Refresh then o.Refresh() end end
end

local function cn(sig, fn)
	local c = sig:Connect(fn)
	conns[#conns + 1] = c
	return c
end

function __AuraFix_tw(o,
    p,
    t,
    st,
    dr)
	local speed = 1
	local duration = math.max(.06,
	    ((t or .2) / speed) * 1.42)
	__AuraFix_activeTweens = __AuraFix_activeTweens or setmetatable({},
	    {__mode = "k"})
	local records = __AuraFix_activeTweens[o]
	if not records then records = {}; __AuraFix_activeTweens[o] = records end
	for i = #records, 1, -1 do
		local rec, overlap = records[i], false
		for property in pairs(p) do if rec.props[property] then overlap = true; break end end
		if overlap then table.remove(records,
		    i); pcall(function() rec.tween:Cancel() end) end
	end
	local tween = TS:Create(o,
	    TweenInfo.new(duration,
	    st or EASE.Quint,
	    dr or DIR.Out),
	    p)
	local record = {tween = tween,
	    props = p}
	records[#records + 1] = record
	tween.Completed:Connect(function()
		local current = __AuraFix_activeTweens and __AuraFix_activeTweens[o]
		if current then
			for i = #current, 1, -1 do if current[i] == record then table.remove(current, i) end end
			if #current == 0 then __AuraFix_activeTweens[o] = nil end
		end
	end)
	tween:Play()
	return tween
end
local tw = __AuraFix_tw

local lo = 0
function __AuraFixUtil.new(class,
    props,
    parent)
	local o = Instance.new(class)
	if o:IsA("GuiObject") then o.BorderSizePixel = 0 end
	if class == "UIListLayout" then o.SortOrder = Enum.SortOrder.LayoutOrder end
	for k, v in pairs(props) do o[k] = v end
	if parent then
		if o:IsA("GuiObject") and parent:FindFirstChildOfClass("UIListLayout") then lo += 1; o.LayoutOrder = lo end
		o.Parent = parent
	end
	return o
end

function __AuraFixUtil.round(o,
    r) __AuraFixUtil.new("UICorner",
    {CornerRadius = UDim.new(0,
    r or 8)},
    o) end
function __AuraFixUtil.stroke(p,
    th,
    col,
    tr)
	return __AuraFixUtil.new("UIStroke",
	    {Thickness = th,
	    Color = col,
	    Transparency = tr,
	    ApplyStrokeMode = Enum.ApplyStrokeMode.Border},
	    p)
end
function __AuraFixUtil.isPress(i) return i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch end

function __AuraFixUtil.acc(o,
    prop,
    get)
	get = get or function() return accent end
	o[prop] = get()
	reg[#reg + 1] = function(instant)
		if instant then o[prop] = get() else tw(o,
		    {[prop] = get()},
		    .35) end
	end
end

function __AuraFixUtil.light(c) return c:Lerp(WHITE,
    .65) end
function __AuraFixUtil.dark(c) return c:Lerp(Color3.new(0,
    0,
    0),
    .8) end
function __AuraFixUtil.shift(c)
	local h, s, v = c:ToHSV()
	return Color3.fromHSV((h + .18) % 1,
	    s,
	    v)
end
function __AuraFixUtil.loop(o,
    props,
    t)
	TS:Create(o,
	    TweenInfo.new(t,
	    EASE.Linear,
	    DIR.InOut,
	    -1),
	    props):Play()
end

function __AuraFixUtil.grad(parent,
    mk,
    props)
	local g = __AuraFixUtil.new("UIGradient",
	    props or {},
	    parent)
	g.Color = mk()
	reg[#reg + 1] = function() g.Color = mk() end
	return g
end

function __AuraFixUtil.lbl(parent,
    text,
    size,
    color,
    extra)
	local p = {BackgroundTransparency = 1,
	    TextSize = size or 13,
	    TextColor3 = color or C.text,
	    Font = Enum.Font.GothamMedium,
	    TextXAlignment = Enum.TextXAlignment.Left,
	    Size = UDim2.fromScale(1,
	    1),
	    TextTruncate = Enum.TextTruncate.AtEnd}
	for k, v in pairs(extra or {}) do p[k] = v end
	local o = __AuraFixUtil.new("TextLabel",
	    p,
	    parent)
	if text ~= "" then bind(o,
	    text) end
	return o
end

function __AuraFixUtil.press(b,
    flat)
	local s = __AuraFixUtil.new("UIScale",
	    {Name = "Pop"},
	    b)
	b.ClipsDescendants = true
	local cr = b:FindFirstChildOfClass("UICorner")
	local ov = __AuraFixUtil.new("Frame",
	    {BackgroundColor3 = WHITE,
	    BackgroundTransparency = 1,
	    Size = UDim2.fromScale(1,
	    1),
	    ZIndex = 4},
	    b)
	if cr then __AuraFixUtil.new("UICorner",
	    {CornerRadius = cr.CornerRadius},
	    ov) end
	cn(b.MouseEnter,
	    function()
		tw(ov,
		    {BackgroundTransparency = .88},
		    .18,
		    EASE.Sine)
		if not flat then tw(s,
		    {Scale = 1.025},
		    .18,
		    EASE.Quad) end
	end)
	cn(b.MouseLeave,
	    function()
		tw(ov,
		    {BackgroundTransparency = 1},
		    .24,
		    EASE.Sine)
		if not flat then tw(s,
		    {Scale = 1},
		    .2,
		    EASE.Quad) end
	end)
	cn(b.InputBegan,
	    function(i)
		if not __AuraFixUtil.isPress(i) then return end
		tw(s,
		    {Scale = .94},
		    .09,
		    EASE.Quad)
		local sz = b.AbsoluteSize
		if flat or sz.X < 1 then return end
		local k = math.max(sz.X,
		    sz.Y) * 2.2
		local rp = __AuraFixUtil.new("Frame",
		    {BackgroundColor3 = WHITE,
		    BackgroundTransparency = .75,
		    AnchorPoint = Vector2.new(.5,
		    .5),
		    Position = UDim2.fromScale((i.Position.X - b.AbsolutePosition.X) / sz.X,
		    (i.Position.Y - b.AbsolutePosition.Y) / sz.Y),
		    Size = UDim2.fromOffset(0,
		    0),
		    ZIndex = 5},
		    b)
		__AuraFixUtil.round(rp,
		    200)
		tw(rp,
		    {Size = UDim2.fromOffset(k,
		    k),
		    BackgroundTransparency = 1},
		    .55).Completed:Connect(function() rp:Destroy() end)
	end)
	cn(b.InputEnded,
	    function(i) if __AuraFixUtil.isPress(i) then tw(s,
	    {Scale = 1},
	    .24,
	    EASE.Back) end end)
end

local CFG_FILE = "AuraMenu.json"
function __AuraFixUtil.loadCfg()
	local ok, data = pcall(function() return HttpService:JSONDecode(readfile(CFG_FILE)) end)
	if ok and type(data) == "table" then cfg = data return true end
	return false
end
function __AuraFixUtil.saveCfg()
	return pcall(function() writefile(CFG_FILE,
	    HttpService:JSONEncode(cfg)) end)
end
__AuraFixUtil.loadCfg()
if type(cfg.accent) == "table" and cfg.accent[3] then accent = Color3.new(cfg.accent[1],
    cfg.accent[2],
    cfg.accent[3]) end
rainbow = cfg.rainbow == true
lang = cfg.lang == 2 and "English" or (cfg.lang == 3 and "Español" or "Русский")

local gui = __AuraFixUtil.new("ScreenGui",
    {Name = "AuraMenu",
    ResetOnSpawn = false,
    IgnoreGuiInset = true,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    DisplayOrder = 100},
    pgui)

-- Fixed dark palette; accent color remains user-adjustable in Settings.
local blur = __AuraFixUtil.new("BlurEffect",
    {Name = "AuraBlur",
    Size = 0},
    Lighting)
local blurOn = true
local skelLayer = __AuraFixUtil.new("Frame",
    {Name = "ESP",
    BackgroundTransparency = 1,
    Size = UDim2.fromScale(1,
    1)},
    gui)

local toastF, toastToken = nil, 0
function __AuraFixUtil.toast(message,
    col)
    local messageText = tostring(T(message) or message or "")
    toastToken += 1
    local myToken = toastToken
    if toastF and toastF.Parent then pcall(function() toastF:Destroy() end) end
    local camera = workspace.CurrentCamera
    local maxWidth = math.max(180,
        math.min(460,
        (camera and camera.ViewportSize.X or 520) - 24))
    local measured = TextService:GetTextSize(messageText,
        14,
        Enum.Font.GothamMedium,
        Vector2.new(maxWidth - 56,
        80))
    local width = math.clamp(measured.X + 58,
        180,
        maxWidth)
    local height = math.clamp(measured.Y + 20,
        42,
        76)
    local f = __AuraFixUtil.new("TextLabel",
        {
        Name = "AuraToast",
            AnchorPoint = Vector2.new(.5,
            0),
            Position = UDim2.new(.5,
            0,
            0,
            -height - 8),
            Size = UDim2.fromOffset(width,
            height),
            BackgroundColor3 = C.bar,
            BackgroundTransparency = .04,
            BorderSizePixel = 0,
            Text = messageText,
            TextColor3 = C.text,
            TextSize = 14,
            Font = Enum.Font.GothamMedium,
            TextWrapped = true,
            TextTruncate = Enum.TextTruncate.None,
            TextXAlignment = Enum.TextXAlignment.Center,
            TextYAlignment = Enum.TextYAlignment.Center,
            ZIndex = 250,
            Visible = true,
            },
            gui)
    toastF = f
    __AuraFixUtil.round(f,
        14)
    __AuraFixUtil.stroke(f,
        1.5,
        col or accent,
        .12)
    local scale = __AuraFixUtil.new("UIScale",
        {Scale = .92},
        f)
    TS:Create(f,
        TweenInfo.new(.32,
        EASE.Quint,
        DIR.Out),
        {Position = UDim2.new(.5,
        0,
        0,
        14)}):Play()
    TS:Create(scale,
        TweenInfo.new(.34,
        EASE.Back,
        DIR.Out),
        {Scale = 1}):Play()
    task.delay(2.8,
        function()
        if f.Parent and myToken == toastToken then
            TS:Create(f,
                TweenInfo.new(.28,
                EASE.Quint,
                DIR.In),
                {Position = UDim2.new(.5,
                0,
                0,
                -height - 8),
                TextTransparency = 1,
                BackgroundTransparency = 1}):Play()
            task.delay(.32,
                function() if f.Parent then f:Destroy() end; if toastF == f then toastF = nil end end)
        end
    end)
end

function __AuraFixUtil.drag(handle,
    target,
    bounds)
	local st = {moved = false}
	local active, inp, origin, start
	local function settle()
		active = false
		local windowMotion = target:FindFirstChild("MainWindow")
		if windowMotion then tw(windowMotion,
		    {Rotation = 0},
		    .34,
		    EASE.Back,
		    DIR.Out) end
	end
	cn(handle.InputBegan,
	    function(i)
		if __AuraFixUtil.isPress(i) then
			active,
			    inp,
			    origin,
			    start,
			    st.moved = true,
			    i,
			    i.Position,
			    target.Position,
			    false
			local windowMotion = target:FindFirstChild("MainWindow")
			if windowMotion then tw(windowMotion,
			    {Rotation = 0},
			    .12,
			    EASE.Sine,
			    DIR.Out) end
			i.Changed:Connect(function() if i.UserInputState == Enum.UserInputState.End then settle() end end)
		end
	end)
	cn(UIS.InputChanged,
	    function(i)
		if active and (i == inp or i.UserInputType == Enum.UserInputType.MouseMovement) then
			local d = i.Position - origin
			if d.Magnitude > 6 then st.moved = true end
			if not st.moved then return end
			local W, H = gui.AbsoluteSize.X,
			    gui.AbsoluteSize.Y
			local x0, x1, y0, y1 = bounds(W,
			    H)
			local nx = math.clamp(start.X.Scale * W + start.X.Offset + d.X,
			    x0,
			    x1) - start.X.Scale * W
			local ny = math.clamp(start.Y.Scale * H + start.Y.Offset + d.Y,
			    y0,
			    y1) - start.Y.Scale * H
			tw(target,
			    {Position = UDim2.new(start.X.Scale,
			    nx,
			    start.Y.Scale,
			    ny)},
			    .075,
			    EASE.Quart,
			    DIR.Out)
			local windowMotion = target:FindFirstChild("MainWindow")
			if windowMotion then tw(windowMotion,
			    {Rotation = math.clamp(d.X / 28,
			    -3.5,
			    3.5)},
			    .11,
			    EASE.Sine,
			    DIR.Out) end
		end
	end)
	return st
end

local cam0 = workspace.CurrentCamera
local vp = cam0 and cam0.ViewportSize or Vector2.new(800,
    400)
if vp.Y < 150 then vp = Vector2.new(800,
    400) end
local baseScale = math.clamp(math.min((vp.Y - 40) / WIN_H,
    (vp.X - 16) / WIN_W),
    .52,
    1)
local baseGT, opened, openTok = 0, false, 0
local startPos = UDim2.new(.5,
    0,
    0,
    math.max(6,
    (vp.Y - WIN_H * baseScale) / 2))

local holder = __AuraFixUtil.new("Frame",
    {Name = "Holder",
    Size = UDim2.fromOffset(WIN_W,
    WIN_H),
    AnchorPoint = Vector2.new(.5,
    0),
    Position = startPos,
    BackgroundTransparency = 1},
    gui)
local main = __AuraFixUtil.new("CanvasGroup",
    {Name = "MainWindow",
    AnchorPoint = Vector2.new(.5,
    0),
    Position = UDim2.fromScale(.5,
    0),
    Size = UDim2.fromScale(1,
    1),
    BackgroundColor3 = C.bg,
    GroupTransparency = 1,
    Visible = false,
    ClipsDescendants = true},
    holder)
__AuraFixUtil.round(main,
    12)
local mscale = __AuraFixUtil.new("UIScale",
    {Scale = baseScale},
    main)
local mstroke = __AuraFixUtil.stroke(main,
    2,
    WHITE,
    .15)
__AuraFixUtil.loop(__AuraFixUtil.grad(mstroke,
    function() return ColorSequence.new({ColorSequenceKeypoint.new(0,
    accent),
    ColorSequenceKeypoint.new(.5,
    __AuraFixUtil.dark(accent)),
    ColorSequenceKeypoint.new(1,
    accent)}) end),
    {Rotation = 360},
    5)

local tint = __AuraFixUtil.new("Frame",
    {Size = UDim2.fromScale(1,
    1)},
    main)
__AuraFixUtil.acc(tint,
    "BackgroundColor3")
__AuraFixUtil.new("UIGradient",
    {Rotation = 90,
    Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0,
    .88),
    NumberSequenceKeypoint.new(1,
    1)})},
    tint)

for k = 1, 2 do
	local o = __AuraFixUtil.new("Frame",
	    {AnchorPoint = Vector2.new(.5,
	    .5),
	    Size = UDim2.fromOffset(220,
	    220),
	    BackgroundTransparency = .93,
	    Position = UDim2.fromScale(k == 1 and .1 or .95,
	    k == 1 and .05 or .98)},
	    main)
	__AuraFixUtil.round(o,
	    110); __AuraFixUtil.acc(o,
	    "BackgroundColor3")
	TS:Create(o,
	    TweenInfo.new(7 + k * 2,
	    EASE.Sine,
	    DIR.InOut,
	    -1,
	    true),
	    {Position = UDim2.fromScale(k == 1 and .3 or .75,
	    k == 1 and .25 or .8),
	    BackgroundTransparency = .97}):Play()
end

for _ = 1, 14 do
	local sz, d = math.random(3,
	    6), math.random(60,
	    120) / 10
	local pt = __AuraFixUtil.new("Frame",
	    {BackgroundTransparency = .9,
	    Size = UDim2.fromOffset(sz,
	    sz),
	    AnchorPoint = Vector2.new(.5,
	    .5),
	    Position = UDim2.fromScale(math.random(),
	    1.05)},
	    main)
	__AuraFixUtil.round(pt,
	    3); __AuraFixUtil.acc(pt,
	    "BackgroundColor3")
	TS:Create(pt,
	    TweenInfo.new(d,
	    EASE.Linear,
	    DIR.Out,
	    -1),
	    {Position = UDim2.fromScale(math.random(),
	    -.05)}):Play()
	TS:Create(pt,
	    TweenInfo.new(d / 2,
	    EASE.Sine,
	    DIR.InOut,
	    -1,
	    true),
	    {BackgroundTransparency = .55}):Play()
end

do
    local Util = __AuraFixUtil
    local new, acc = Util.new, Util.acc
    local nk = NumberSequenceKeypoint.new

    for i = 1, 26 do
        local s = math.random(1, 2)
        local f = new("Frame", {AnchorPoint = Vector2.new(.5, .5), Position = UDim2.fromScale(math.random(), math.random()), Size = UDim2.fromOffset(s, s), BackgroundTransparency = .72, BackgroundColor3 = WHITE}, main)
        Util.round(f, 2)
        if i % 3 ~= 0 then acc(f, "BackgroundColor3") end
        local d = math.random(18, 46) / 10
        task.delay(math.random() * 3, function()
            if f.Parent then TS:Create(f, TweenInfo.new(d, EASE.Sine, DIR.InOut, -1, true), {BackgroundTransparency = .96}):Play() end
        end)
    end

    for k = 1, 3 do
        local s = new("Frame", {AnchorPoint = Vector2.new(.5, .5), Rotation = -28, Size = UDim2.fromOffset(2 + k, 330), Position = UDim2.fromScale(-.2, .5), BackgroundColor3 = WHITE, BackgroundTransparency = .5}, main)
        new("UIGradient", {Rotation = 90, Transparency = NumberSequence.new({nk(0, 1), nk(.5, .82), nk(1, 1)})}, s)
        acc(s, "BackgroundColor3", function() return accent:Lerp(WHITE, .35) end)
        task.spawn(function()
            task.wait(k * 2.3)
            while s.Parent do
                s.Position = UDim2.fromScale(-.15, .3 + math.random() * .4)
                local tt = TS:Create(s, TweenInfo.new(5.5 + k, EASE.Sine, DIR.InOut), {Position = UDim2.fromScale(1.15, .3 + math.random() * .4)})
                tt:Play()
                tt.Completed:Wait()
                task.wait(2 + math.random() * 5)
            end
        end)
    end

    for k = 1, 2 do
        local r = new("Frame", {AnchorPoint = Vector2.new(.5, .5), Size = UDim2.fromOffset(110 + k * 40, 110 + k * 40), Position = UDim2.fromScale(k == 1 and .92 or .06, k == 1 and .1 or .92), BackgroundTransparency = 1}, main)
        Util.round(r, 200)
        local st = Util.stroke(r, 1.5, accent, .82)
        acc(st, "Color")
        local g = new("UIGradient", {Transparency = NumberSequence.new({nk(0, 0), nk(.5, .9), nk(1, 0)})}, st)
        Util.loop(g, {Rotation = 360}, 9 + k * 4)
    end

    for gx = 0, 7 do
        for gy = 0, 2 do
            local f = new("Frame", {Position = UDim2.new(1, -150 + gx * 12, 1, -50 + gy * 12), Size = UDim2.fromOffset(2, 2), BackgroundTransparency = .9}, main)
            acc(f, "BackgroundColor3")
            task.delay((gx + gy) * .18, function()
                if f.Parent then TS:Create(f, TweenInfo.new(1.4, EASE.Sine, DIR.InOut, -1, true), {BackgroundTransparency = .55}):Play() end
            end)
        end
    end

    for i = 1, 6 do
        local size = math.random(10, 22)
        local ring = new("Frame", {AnchorPoint = Vector2.new(.5, .5), Size = UDim2.fromOffset(size, size), Position = UDim2.fromScale(math.random(), 1.1), BackgroundTransparency = 1}, main)
        Util.round(ring, size)
        local st = Util.stroke(ring, 1, accent, .8)
        acc(st, "Color")
        local d = 9 + math.random() * 8
        task.delay(math.random() * d, function()
            if not ring.Parent then return end
            TS:Create(ring, TweenInfo.new(d, EASE.Linear, DIR.In, -1), {Position = UDim2.fromScale(math.random(), -.1)}):Play()
            TS:Create(st, TweenInfo.new(d / 2, EASE.Sine, DIR.InOut, -1, true), {Transparency = .45}):Play()
        end)
    end

    local scan = new("Frame", {Size = UDim2.new(1, 0, 0, 36), Position = UDim2.new(0, 0, 0, -40), BackgroundColor3 = WHITE, BackgroundTransparency = .5}, main)
    acc(scan, "BackgroundColor3", function() return accent:Lerp(WHITE, .5) end)
    new("UIGradient", {Rotation = 90, Transparency = NumberSequence.new({nk(0, 1), nk(.5, .955), nk(1, 1)})}, scan)
    task.spawn(function()
        while scan.Parent do
            task.wait(4 + math.random() * 3)
            if not scan.Parent then break end
            scan.Position = UDim2.new(0, 0, 0, -40)
            local tt = TS:Create(scan, TweenInfo.new(2.6, EASE.Sine, DIR.InOut), {Position = UDim2.new(0, 0, 1, 4)})
            tt:Play()
            tt.Completed:Wait()
        end
    end)

    task.spawn(function()
        while main.Parent do
            task.wait(3 + math.random() * 5)
            if not main.Parent then break end
            if main.Visible then
                local sx, sy = math.random() * .7, math.random() * .35
                local m = new("Frame", {AnchorPoint = Vector2.new(1, .5), Rotation = 24, Position = UDim2.fromScale(sx, sy), Size = UDim2.fromOffset(0, 2), BackgroundColor3 = WHITE, BackgroundTransparency = .1}, main)
                Util.round(m, 1)
                new("UIGradient", {Transparency = NumberSequence.new({nk(0, 1), nk(1, 0)})}, m)
                TS:Create(m, TweenInfo.new(.7, EASE.Quad, DIR.Out), {Size = UDim2.fromOffset(46, 2), Position = UDim2.fromScale(sx + .18, sy + .12)}):Play()
                task.delay(.55, function()
                    if m.Parent then TS:Create(m, TweenInfo.new(.3), {BackgroundTransparency = 1}):Play() end
                end)
                task.delay(1, function() if m.Parent then m:Destroy() end end)
            end
        end
    end)
    for k = 1, 2 do
        local v = new("Frame", {AnchorPoint = Vector2.new(0, k == 1 and 0 or 1), Position = UDim2.fromScale(0, k == 1 and 0 or 1), Size = UDim2.new(1, 0, 0, 46), BackgroundColor3 = Color3.new(0, 0, 0), BackgroundTransparency = .8}, main)
        new("UIGradient", {Rotation = k == 1 and 90 or 270, Transparency = NumberSequence.new({nk(0, 0), nk(1, 1)})}, v)
    end

    local glow = new("Frame", {AnchorPoint = Vector2.new(.5, .5), Position = UDim2.fromOffset(48, 18), Size = UDim2.fromOffset(150, 70), BackgroundTransparency = .93}, main)
    Util.round(glow, 70)
    acc(glow, "BackgroundColor3")
    TS:Create(glow, TweenInfo.new(3.4, EASE.Sine, DIR.InOut, -1, true), {BackgroundTransparency = .97, Size = UDim2.fromOffset(190, 84)}):Play()

    for i = 1, 8 do
        local sz = math.random(2, 3)
        local d = new("Frame", {AnchorPoint = Vector2.new(.5, .5), Position = UDim2.fromScale(math.random(), math.random()), Size = UDim2.fromOffset(sz, sz), BackgroundTransparency = .88}, main)
        Util.round(d, 3)
        acc(d, "BackgroundColor3")
        local dur = 9 + math.random() * 8
        TS:Create(d, TweenInfo.new(dur, EASE.Sine, DIR.InOut, -1, true), {Position = UDim2.fromScale(math.random(), math.random())}):Play()
        TS:Create(d, TweenInfo.new(dur / 3, EASE.Sine, DIR.InOut, -1, true), {BackgroundTransparency = .7}):Play()
    end
end

do
    -- extra background detail layer (sits under the top bar / sidebar / content)
    local Util = __AuraFixUtil
    local new, acc = Util.new, Util.acc
    local nk = NumberSequenceKeypoint.new
    local rng = Random.new()
    local half = Vector2.new(.5, .5)

    -- 1) dot grid with a diagonal wave
    local COLS, ROWS = 13, 7
    for gx = 0, COLS - 1 do
        for gy = 0, ROWS - 1 do
            local f = new("Frame", {AnchorPoint = half, Position = UDim2.fromScale((gx + .5) / COLS, (gy + .5) / ROWS), Size = UDim2.fromOffset(2, 2), BackgroundTransparency = .94}, main)
            Util.round(f, 2)
            acc(f, "BackgroundColor3")
            task.delay((gx + gy) * .14, function()
                if f.Parent then
                    TS:Create(f, TweenInfo.new(1.7, EASE.Sine, DIR.InOut, -1, true, ((COLS - gx) % 4) * .2), {BackgroundTransparency = .76}):Play()
                end
            end)
        end
    end

    -- 2) HUD corner brackets with pulsing nodes
    for c = 1, 4 do
        local right, bottom = c % 2 == 0, c > 2
        local ax, ay = right and 1 or 0, bottom and 1 or 0
        local sx, sy = right and -1 or 1, bottom and -1 or 1
        local posY = bottom and UDim2.new(1, -5, 1, -5) or UDim2.new(0, 5, 0, TOP + 5)
        local px = right and -5 or 5
        local pos = UDim2.new(ax, px, posY.Y.Scale, posY.Y.Offset)
        local h = new("Frame", {AnchorPoint = Vector2.new(ax, ay), Position = pos, Size = UDim2.fromOffset(16, 1), BackgroundTransparency = .55}, main)
        local v = new("Frame", {AnchorPoint = Vector2.new(ax, ay), Position = pos, Size = UDim2.fromOffset(1, 16), BackgroundTransparency = .55}, main)
        local node = new("Frame", {AnchorPoint = Vector2.new(ax, ay), Position = pos + UDim2.fromOffset(sx * 3, sy * 3), Size = UDim2.fromOffset(3, 3), BackgroundTransparency = .4}, main)
        Util.round(node, 2)
        for _, o in ipairs({h, v, node}) do
            acc(o, "BackgroundColor3")
            task.delay(c * .45, function()
                if o.Parent then TS:Create(o, TweenInfo.new(2.2, EASE.Sine, DIR.InOut, -1, true), {BackgroundTransparency = .88}):Play() end
            end)
        end
    end

    -- 3) drifting plus marks
    for _ = 1, 7 do
        local p = new("Frame", {AnchorPoint = half, Position = UDim2.fromScale(rng:NextNumber(), rng:NextNumber()), Size = UDim2.fromOffset(7, 7), BackgroundTransparency = 1}, main)
        local a = new("Frame", {AnchorPoint = half, Position = UDim2.fromScale(.5, .5), Size = UDim2.new(1, 0, 0, 1), BackgroundTransparency = .8}, p)
        local b = new("Frame", {AnchorPoint = half, Position = UDim2.fromScale(.5, .5), Size = UDim2.new(0, 1, 1, 0), BackgroundTransparency = .8}, p)
        acc(a, "BackgroundColor3"); acc(b, "BackgroundColor3")
        local d = 11 + rng:NextNumber() * 9
        TS:Create(p, TweenInfo.new(d, EASE.Sine, DIR.InOut, -1, true), {Position = UDim2.fromScale(rng:NextNumber(), rng:NextNumber()), Rotation = 90}):Play()
        TS:Create(a, TweenInfo.new(d / 3, EASE.Sine, DIR.InOut, -1, true), {BackgroundTransparency = .95}):Play()
        TS:Create(b, TweenInfo.new(d / 3, EASE.Sine, DIR.InOut, -1, true), {BackgroundTransparency = .95}):Play()
    end

    -- 4) aurora ribbons
    for k = 1, 2 do
        local aur = new("Frame", {AnchorPoint = half, Position = UDim2.fromScale(.5, k == 1 and .35 or .7), Size = UDim2.fromScale(1.6, .2), Rotation = k == 1 and -14 or 10, BackgroundTransparency = .9}, main)
        acc(aur, "BackgroundColor3", function() return k == 1 and accent or Util.shift(accent) end)
        new("UIGradient", {Rotation = 90, Transparency = NumberSequence.new({nk(0, 1), nk(.5, 0), nk(1, 1)})}, aur)
        TS:Create(aur, TweenInfo.new(13 + k * 4, EASE.Sine, DIR.InOut, -1, true), {Position = UDim2.fromScale(.5, k == 1 and .65 or .3), Rotation = k == 1 and -4 or 18, BackgroundTransparency = .94}):Play()
    end

    -- 5) circuit traces with travelling data packets
    for k = 1, 3 do
        local y = .22 + k * .2
        local line = new("Frame", {AnchorPoint = Vector2.new(0, .5), Position = UDim2.fromScale(0, y), Size = UDim2.new(1, 0, 0, 1), BackgroundTransparency = .95}, main)
        acc(line, "BackgroundColor3")
        local pk = new("Frame", {AnchorPoint = half, Position = UDim2.fromScale(-.1, y), Size = UDim2.fromOffset(34, 1), BackgroundTransparency = .35, BackgroundColor3 = WHITE}, main)
        new("UIGradient", {Transparency = NumberSequence.new({nk(0, 1), nk(.8, 0), nk(1, 1)})}, pk)
        acc(pk, "BackgroundColor3", function() return accent:Lerp(WHITE, .45) end)
        TS:Create(pk, TweenInfo.new(5 + k * 1.3, EASE.Linear, DIR.Out, -1, false, k * 1.7), {Position = UDim2.fromScale(1.1, y)}):Play()
    end

    -- 6) left edge ruler with travelling highlight
    for i = 0, 19 do
        local t = new("Frame", {Position = UDim2.new(0, 1, 0, TOP + 8 + i * 9), Size = UDim2.fromOffset(i % 5 == 0 and 5 or 3, 1), BackgroundTransparency = .86}, main)
        acc(t, "BackgroundColor3")
        task.delay(i * .09, function()
            if t.Parent then TS:Create(t, TweenInfo.new(1.1, EASE.Sine, DIR.InOut, -1, true, 1.6), {BackgroundTransparency = .35}):Play() end
        end)
    end

    -- 7) film grain
    local grain = {}
    for i = 1, 26 do
        grain[i] = new("Frame", {Size = UDim2.fromOffset(1, 1), BackgroundTransparency = .93, BackgroundColor3 = WHITE, Position = UDim2.fromScale(rng:NextNumber(), rng:NextNumber())}, main)
    end
    task.spawn(function()
        while main.Parent do
            task.wait(.24)
            if main.Visible then
                for _, g in ipairs(grain) do
                    g.Position = UDim2.fromScale(rng:NextNumber(), rng:NextNumber())
                    g.BackgroundTransparency = .88 + rng:NextNumber() * .09
                end
            end
        end
    end)

    -- 8) random sparkle glints
    task.spawn(function()
        while main.Parent do
            task.wait(1.4 + rng:NextNumber() * 2.4)
            if main.Parent and main.Visible then
                local g = new("Frame", {AnchorPoint = half, Position = UDim2.fromScale(.05 + rng:NextNumber() * .9, .18 + rng:NextNumber() * .75), Size = UDim2.fromOffset(4, 4), BackgroundTransparency = 1}, main)
                local a = new("Frame", {AnchorPoint = half, Position = UDim2.fromScale(.5, .5), Size = UDim2.new(1, 0, 0, 1), BackgroundColor3 = WHITE, BackgroundTransparency = .35}, g)
                local b = new("Frame", {AnchorPoint = half, Position = UDim2.fromScale(.5, .5), Size = UDim2.new(0, 1, 1, 0), BackgroundColor3 = WHITE, BackgroundTransparency = .35}, g)
                TS:Create(g, TweenInfo.new(.9, EASE.Quint, DIR.Out), {Size = UDim2.fromOffset(18, 18), Rotation = 45}):Play()
                TS:Create(a, TweenInfo.new(.9, EASE.Sine), {BackgroundTransparency = 1}):Play()
                TS:Create(b, TweenInfo.new(.9, EASE.Sine), {BackgroundTransparency = 1}):Play()
                task.delay(1, function() if g.Parent then g:Destroy() end end)
            end
        end
    end)

    -- 9) soft light that follows the cursor
    if UIS.MouseEnabled then
        local lens = new("Frame", {AnchorPoint = half, Size = UDim2.fromOffset(120, 120), BackgroundTransparency = 1, Visible = false}, main)
        Util.round(lens, 60)
        acc(lens, "BackgroundColor3")
        local lensS = Util.stroke(lens, 1, accent, 1)
        acc(lensS, "Color")
        local gp, amt = nil, 0
        cn(RS.Heartbeat, function(dt)
            if not main.Visible then return end
            local m = UIS:GetMouseLocation() - GuiService:GetGuiInset()
            local ap, sz = main.AbsolutePosition, main.AbsoluteSize
            local inside = m.X >= ap.X and m.X <= ap.X + sz.X and m.Y >= ap.Y and m.Y <= ap.Y + sz.Y
            local sc = math.max(mscale.Scale, .01)
            if inside then
                local goal = (m - ap) / sc
                gp = gp and gp:Lerp(goal, 1 - math.exp(-dt * 10)) or goal
                lens.Position = UDim2.fromOffset(gp.X, gp.Y)
            end
            amt += ((inside and 1 or 0) - amt) * (1 - math.exp(-dt * 6))
            lens.Visible = amt > .02
            lens.BackgroundTransparency = 1 - .06 * amt
            lensS.Transparency = 1 - .22 * amt
        end)
    end
end

local top = __AuraFixUtil.new("Frame",
    {Size = UDim2.new(1, 0, 0, TOP),
    BackgroundColor3 = C.bar},
    main)
local title = __AuraFixUtil.lbl(top,
    "AURA",
    16,
    WHITE,
    {Position = UDim2.fromOffset(12,
    0),
    Size = UDim2.fromOffset(56,
    TOP),
    Font = Enum.Font.GothamBlack})
__AuraFixUtil.loop(__AuraFixUtil.grad(title,
    function() return ColorSequence.new({ColorSequenceKeypoint.new(0,
    accent),
    ColorSequenceKeypoint.new(.5,
    __AuraFixUtil.light(accent)),
    ColorSequenceKeypoint.new(1,
    accent)}) end,
    {Offset = Vector2.new(-.5,
    0)}),
    {Offset = Vector2.new(.5,
    0)},
    1.8)
local line = __AuraFixUtil.new("Frame",
    {Position = UDim2.new(0,
    0,
    1,
    -2),
    Size = UDim2.new(1,
    0,
    0,
    2)},
    top)
__AuraFixUtil.acc(line,
    "BackgroundColor3")
__AuraFixUtil.loop(__AuraFixUtil.new("UIGradient",
    {Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0,
    .9),
    NumberSequenceKeypoint.new(.5,
    0),
    NumberSequenceKeypoint.new(1,
    .9)}),
    Offset = Vector2.new(-1,
    0)},
    line),
    {Offset = Vector2.new(1,
    0)},
    2.2)

local mini = {}
local miniF = __AuraFixUtil.new("Frame",
    {BackgroundTransparency = 1,
    AnchorPoint = Vector2.new(1,
    .5),
    Position = UDim2.new(1,
    -84,
    .5,
    0),
    Size = UDim2.fromOffset(16,
    12)},
    top)
for k = 1, 3 do
	local b = __AuraFixUtil.new("Frame",
	    {AnchorPoint = Vector2.new(0,
	    1),
	    Position = UDim2.new(0,
	    (k - 1) * 6,
	    1,
	    0),
	    Size = UDim2.fromOffset(4,
	    3)},
	    miniF)
	__AuraFixUtil.round(b,
	    2); __AuraFixUtil.acc(b,
	    "BackgroundColor3")
	mini[k] = {f = b,
	    h = 3}
end

function __AuraFixUtil.topBtn(txt,
    n)
	local b = __AuraFixUtil.new("TextButton",
	    {Text = txt,
	    Font = Enum.Font.GothamBold,
	    TextSize = 16,
	    TextColor3 = C.text,
	    AutoButtonColor = false,
	    BackgroundColor3 = C.card2,
	    Size = UDim2.fromOffset(28,
	    22),
	    AnchorPoint = Vector2.new(1,
	    .5),
	    Position = UDim2.new(1,
	    -8 - (n - 1) * 34,
	    .5,
	    -1)},
	    top)
	__AuraFixUtil.round(b,
	    6); __AuraFixUtil.press(b)
	return b
end
local closeB, colB = __AuraFixUtil.topBtn("×",
    1), __AuraFixUtil.topBtn("–",
    2)
cn(closeB.MouseEnter,
    function() tw(closeB,
    {BackgroundColor3 = C.bad},
    .2) end)
cn(closeB.MouseLeave,
    function() tw(closeB,
    {BackgroundColor3 = C.card2},
    .25) end)

__AuraFixUtil.drag(top,
    holder,
    function(W,
    H) return 40,
    W - 40,
    0,
    H - 40 end)

local side = __AuraFixUtil.new("Frame",
    {Position = UDim2.fromOffset(6,
    TOP + 8),
    Size = UDim2.new(0,
    SB,
    1,
    -TOP - 14),
    BackgroundTransparency = 1},
    main)
local sideDivider = __AuraFixUtil.new("Frame",
    {Position = UDim2.fromOffset(SB + 7,
    TOP + 14),
    Size = UDim2.new(0,
    1,
    1,
    -TOP - 28),
    BackgroundColor3 = WHITE,
    BackgroundTransparency = .92},
    main)
local CPOS = UDim2.fromOffset(SB + 12,
    TOP + 8)
local content = __AuraFixUtil.new("CanvasGroup",
    {Position = CPOS,
    Size = UDim2.new(1,
    -SB - 18,
    1,
    -TOP - 14),
    BackgroundTransparency = 1},
    main)
local isCollapsed, collapseToken = false, 0
local fullMainSize = UDim2.fromScale(1,
    1)
local collapsedMainSize = UDim2.new(1,
    0,
    0,
    TOP)

function __AuraFixUtil.setOpen(v)
    if opened == v then return end
    opened = v; openTok += 1
    local my = openTok
    local resting = UDim2.fromScale(.5,
        0)
    if v then
        if isCollapsed then
            isCollapsed = false
            collapseToken += 1
            colB.Text = "–"
            main.Size = fullMainSize
            content.Visible = true
            content.GroupTransparency = 0
            side.Visible = true
            sideDivider.Visible = true
        end
        main.Visible = true
        main.Position = resting + UDim2.fromOffset(0,
            22)
        main.Rotation = -2.2
        main.GroupTransparency = 1
        mscale.Scale = baseScale * .82
        tw(blur,
            {Size = blurOn and 13 or 0},
            .72,
            EASE.Sine)
        tw(main,
            {GroupTransparency = baseGT,
            Position = resting,
            Rotation = 0},
            .68,
            EASE.Quint,
            DIR.Out)
        tw(mscale,
            {Scale = baseScale},
            .72,
            EASE.Back,
            DIR.Out)
    else
        tw(main,
            {GroupTransparency = 1,
            Position = resting + UDim2.fromOffset(0,
            22),
            Rotation = 2.2},
            .46,
            EASE.Quint,
            DIR.In)
        tw(blur,
            {Size = 0},
            .48,
            EASE.Sine)
        tw(mscale,
            {Scale = baseScale * .86},
            .46,
            EASE.Quint,
            DIR.In)
        task.delay(.48,
            function() if openTok == my then main.Visible = false; main.Rotation = 0 end end)
    end
end
cn(closeB.Activated,
    function() __AuraFixUtil.setOpen(false) end)

-- The minus button minimizes the window to its title bar; it does not close it.
local function setCollapsed(value)
    if isCollapsed == value then return end
    isCollapsed = value
    collapseToken += 1
    local token = collapseToken
    colB.Text = value and "+" or "–"
    if value then
        -- Fade the content slightly before clipping it to the title bar.
        tw(content,
            {GroupTransparency = 1},
            .14,
            EASE.Sine)
        tw(main,
            {Size = collapsedMainSize},
            .32,
            EASE.Quint,
            DIR.Out)
        task.delay(.16,
            function()
            if collapseToken == token and isCollapsed then
                content.Visible = false
                side.Visible = false
                sideDivider.Visible = false
            end
        end)
    else
        content.Visible = true
        side.Visible = true
        sideDivider.Visible = true
        content.GroupTransparency = 1
        tw(main,
            {Size = fullMainSize},
            .38,
            EASE.Back,
            DIR.Out)
        tw(content,
            {GroupTransparency = 0},
            .3,
            EASE.Quint,
            DIR.Out)
    end
end
cn(colB.Activated,
    function()
    if not opened then return end
    setCollapsed(not isCollapsed)
end)

local fab = __AuraFixUtil.new("TextButton",
    {Text = "A",
    Font = Enum.Font.GothamBlack,
    TextSize = 20,
    TextColor3 = WHITE,
    AutoButtonColor = false,
    Size = UDim2.fromOffset(46,
    46),
    Position = UDim2.new(0,
    14,
    .5,
    -23)},
    gui)
__AuraFixUtil.round(fab,
    23); __AuraFixUtil.acc(fab,
    "BackgroundColor3"); __AuraFixUtil.press(fab,
    true)
local fs = __AuraFixUtil.stroke(fab,
    2,
    accent,
    .5); __AuraFixUtil.acc(fs,
    "Color")
TS:Create(fs,
    TweenInfo.new(1.4,
    EASE.Sine,
    DIR.InOut,
    -1,
    true),
    {Thickness = 6,
    Transparency = .9}):Play()
local fabDrag = __AuraFixUtil.drag(fab,
    fab,
    function(W,
    H) return 0,
    W - 46,
    0,
    H - 46 end)
cn(fab.Activated,
    function()
	if fabDrag.moved then return end
	__AuraFixUtil.setOpen(not opened)
	tw(fab,
	    {Rotation = fab.Rotation + 360},
	    .7,
	    EASE.Back)
end)

local cols = {Color3.fromRGB(130,
    100,
    255),
    Color3.fromRGB(0,
    200,
    255),
    Color3.fromRGB(255,
    85,
    150),
    Color3.fromRGB(60,
    220,
    130),
    Color3.fromRGB(255,
    160,
    50),
    Color3.fromRGB(255,
    75,
    85)}
local swb = {}
function __AuraFixUtil.mark(idx)
	for k, b in pairs(swb) do tw(b.S,
	    {Transparency = k == idx and 0 or 1},
	    .25) end
end
function __AuraFixUtil.setAccent(col,
    idx,
    instant)
	accent = col
	cfg.accent = {col.R,
	    col.G,
	    col.B}
	for _, f in ipairs(reg) do f(instant) end
	__AuraFixUtil.mark(idx)
end

function __AuraFixUtil.card(p,
    h)
	local f = __AuraFixUtil.new("Frame",
	    {Size = UDim2.new(1,
	    0,
	    0,
	    h),
	    BackgroundColor3 = C.card},
	    p)
	__AuraFixUtil.round(f,
	    8)
	return f, __AuraFixUtil.stroke(f,
	    1,
	    WHITE,
	    .93)
end

function __AuraFixUtil.hov(b,
    f,
    st)
	cn(b.MouseEnter,
	    function() tw(st,
	    {Transparency = .75},
	    .2); tw(f,
	    {BackgroundColor3 = C.card:Lerp(WHITE,
	    .035)},
	    .2) end)
	cn(b.MouseLeave,
	    function() tw(st,
	    {Transparency = .93},
	    .25); tw(f,
	    {BackgroundColor3 = C.card},
	    .25) end)
end

function __AuraFixUtil.section(p,
    text)
	local f = __AuraFixUtil.new("Frame",
	    {Size = UDim2.new(1,
	    0,
	    0,
	    18),
	    BackgroundTransparency = 1},
	    p)
	local bar = __AuraFixUtil.new("Frame",
	    {AnchorPoint = Vector2.new(0,
	    .5),
	    Position = UDim2.new(0,
	    1,
	    .5,
	    1),
	    Size = UDim2.fromOffset(3,
	    10)},
	    f)
	__AuraFixUtil.round(bar,
	    2); __AuraFixUtil.acc(bar,
	    "BackgroundColor3")
	__AuraFixUtil.lbl(f,
	    text,
	    11,
	    C.sub,
	    {Position = UDim2.fromOffset(10,
	    0),
	    Size = UDim2.new(1,
	    -10,
	    1,
	    0),
	    Font = Enum.Font.GothamBold})
	return f
end

function __AuraFixUtil.row(p,
    h)
	local f = __AuraFixUtil.new("Frame",
	    {Size = UDim2.new(1,
	    0,
	    0,
	    h),
	    BackgroundTransparency = 1},
	    p)
	__AuraFixUtil.new("UIListLayout",
	    {FillDirection = Enum.FillDirection.Horizontal,
	    Padding = UDim.new(0,
	    6)},
	    f)
	return f
end

function __AuraFixUtil.button(p,
    text,
    cb,
    primary,
    size)
	local b = __AuraFixUtil.new("TextButton",
	    {Font = Enum.Font.GothamBold,
	    TextSize = 13,
	    TextColor3 = C.text,
	    AutoButtonColor = false,
	    BackgroundColor3 = C.card2,
	    Size = size or UDim2.new(1,
	    0,
	    0,
	    32)},
	    p)
	bind(b,
	    text)
	__AuraFixUtil.round(b,
	    8); __AuraFixUtil.press(b)
	if primary then __AuraFixUtil.acc(b,
	    "BackgroundColor3") end
	if cb then cn(b.Activated,
	    cb) end
	return b
end

function __AuraFixUtil.toggle(p,
    text,
    def,
    cb,
    key)
	local originalDef = def and true or false
	local f, st = __AuraFixUtil.card(p,
	    36)
	__AuraFixUtil.lbl(f,
	    text,
	    13,
	    nil,
	    {Position = UDim2.fromOffset(10,
	    0),
	    Size = UDim2.new(1,
	    -60,
	    1,
	    0)})
	local b = __AuraFixUtil.new("TextButton",
	    {Text = "",
	    AutoButtonColor = false,
	    BackgroundTransparency = 1,
	    Size = UDim2.fromScale(1,
	    1)},
	    f)
	local fromCfg = key and cfg[key] ~= nil
	local on = def and true or false
	if fromCfg then on = cfg[key] and true or false end
	local sw = __AuraFixUtil.new("Frame",
	    {AnchorPoint = Vector2.new(1,
	    .5),
	    Position = UDim2.new(1,
	    -10,
	    .5,
	    0),
	    Size = UDim2.fromOffset(38,
	    20)},
	    f)
	__AuraFixUtil.round(sw,
	    10)
	__AuraFixUtil.acc(sw,
	    "BackgroundColor3",
	    function() return on and accent or C.off end)
	local knob = __AuraFixUtil.new("Frame",
	    {BackgroundColor3 = WHITE,
	    AnchorPoint = Vector2.new(0,
	    .5),
	    Size = UDim2.fromOffset(14,
	    14),
	    Position = UDim2.new(0,
	    3,
	    .5,
	    0)},
	    sw)
	__AuraFixUtil.round(knob,
	    7)
	local held = false
	local function place(fast)
		local w = held and 18 or 14
		local props = {Size = UDim2.fromOffset(w,
		    14),
		    Position = UDim2.new(0,
		    on and 35 - w or 3,
		    .5,
		    0)}
		if fast then for k, v in pairs(props) do knob[k] = v end else tw(knob,
		    props,
		    .3,
		    EASE.Back) end
	end
	place(true)
	local obj = {Default = originalDef}
	function obj.Set(v,
	    silent)
		on = v and true or false
		if key then cfg[key] = on end
		tw(sw,
		    {BackgroundColor3 = on and accent or C.off},
		    .2)
		place()
		if not silent and cb then cb(on) end
	end
	cn(b.InputBegan,
	    function(i) if __AuraFixUtil.isPress(i) then held = true; place() end end)
	cn(b.InputEnded,
	    function(i) if __AuraFixUtil.isPress(i) then held = false; place() end end)
	cn(b.Activated,
	    function() obj.Set(not on) end)
	__AuraFixUtil.hov(b,
	    f,
	    st)
	if key then ctl[key] = obj; cfg[key] = on end
	if fromCfg and cb then cb(on) end
	return obj
end

function __AuraFixUtil.slider(p,
    text,
    min,
    max,
    def,
    fmt,
    cb,
    step,
    key,
    commit)
	local originalDef = def
	local f, st = __AuraFixUtil.card(p,
	    50)
	__AuraFixUtil.lbl(f,
	    text,
	    13,
	    nil,
	    {Position = UDim2.fromOffset(10,
	    5),
	    Size = UDim2.new(1,
	    -90,
	    0,
	    20)})
	local val = __AuraFixUtil.lbl(f,
	    "",
	    12,
	    C.sub,
	    {AnchorPoint = Vector2.new(1,
	    0),
	    Position = UDim2.new(1,
	    -10,
	    0,
	    5),
	    Size = UDim2.fromOffset(76,
	    20),
	    TextXAlignment = Enum.TextXAlignment.Right})
	local hit = __AuraFixUtil.new("TextButton",
	    {Text = "",
	    AutoButtonColor = false,
	    BackgroundTransparency = 1,
	    Position = UDim2.fromOffset(0,
	    26),
	    Size = UDim2.new(1,
	    0,
	    0,
	    24)},
	    f)
	local track = __AuraFixUtil.new("Frame",
	    {BackgroundColor3 = C.card2,
	    AnchorPoint = Vector2.new(0,
	    .5),
	    Position = UDim2.new(0,
	    10,
	    .5,
	    0),
	    Size = UDim2.new(1,
	    -20,
	    0,
	    6)},
	    hit)
	__AuraFixUtil.round(track,
	    3)
	local fill = __AuraFixUtil.new("Frame",
	    {BackgroundColor3 = WHITE,
	    Size = UDim2.fromScale(0,
	    1)},
	    track)
	__AuraFixUtil.round(fill,
	    3)
	__AuraFixUtil.grad(fill,
	    function() return ColorSequence.new(accent:Lerp(Color3.new(0,
	    0,
	    0),
	    .3),
	    accent) end)
	local knob = __AuraFixUtil.new("Frame",
	    {BackgroundColor3 = WHITE,
	    AnchorPoint = Vector2.new(.5,
	    .5),
	    Size = UDim2.fromOffset(14,
	    14),
	    Position = UDim2.fromScale(0,
	    .5),
	    ZIndex = 2},
	    track)
	__AuraFixUtil.round(knob,
	    7)
	local ks = __AuraFixUtil.stroke(knob,
	    0,
	    accent,
	    .55); __AuraFixUtil.acc(ks,
	    "Color")
	local fromCfg = key and cfg[key] ~= nil
	if fromCfg then def = cfg[key] end
	local obj = {Label = val,
	    Dragging = false,
	    Default = originalDef}
	local cur = def
	local function set(v, silent, instant)
		v = math.clamp(v,
		    min,
		    max)
		if step then v = math.floor(v / step + .5) * step end
		cur = v
		if key then cfg[key] = v end
		local a = (v - min) / (max - min)
		if instant then
			fill.Size = UDim2.fromScale(a,
			    1); knob.Position = UDim2.fromScale(a,
			    .5)
		else
			tw(fill,
			    {Size = UDim2.fromScale(a,
			    1)},
			    .12,
			    EASE.Quad)
			tw(knob,
			    {Position = UDim2.fromScale(a,
			    .5)},
			    .12,
			    EASE.Quad)
		end
		local s = fmt and fmt(v) or tostring(v)
		if val.Text ~= s then val.Text = s end
		if not silent and cb and not (commit and obj.Dragging) then cb(v) end
	end
	local function fromX(x)
		set(min + (max - min) * math.clamp((x - track.AbsolutePosition.X) / track.AbsoluteSize.X,
		    0,
		    1))
	end
	cn(hit.InputBegan,
	    function(i)
		if not __AuraFixUtil.isPress(i) then return end
		obj.Dragging = true
		local sf = f:FindFirstAncestorOfClass("ScrollingFrame")
		if sf then sf.ScrollingEnabled = false end
		fromX(i.Position.X)
		tw(knob,
		    {Size = UDim2.fromOffset(19,
		    19)},
		    .15); tw(ks,
		    {Thickness = 5},
		    .2); tw(val,
		    {TextColor3 = accent},
		    .15)
		local conn
		conn = UIS.InputChanged:Connect(function(c)
			if c == i or c.UserInputType == Enum.UserInputType.MouseMovement then fromX(c.Position.X) end
		end)
		i.Changed:Connect(function()
			if i.UserInputState == Enum.UserInputState.End then
				conn:Disconnect(); obj.Dragging = false
				if sf then sf.ScrollingEnabled = true end
				if commit and cb then cb(cur) end
				tw(knob,
				    {Size = UDim2.fromOffset(14,
				    14)},
				    .25,
				    EASE.Back); tw(ks,
				    {Thickness = 0},
				    .3); tw(val,
				    {TextColor3 = C.sub},
				    .3)
			end
		end)
	end)
	__AuraFixUtil.hov(hit,
	    f,
	    st)
	obj.Set = set
	function obj.Refresh() set(cur,
	    true,
	    true) end
	set(def,
	    not fromCfg,
	    true)
	if key then ctl[key] = obj end
	return obj
end

function __AuraFixUtil.segment(p,
    text,
    opts,
    cb,
    def,
    key)
	local originalDef = def or 1
	local f, st = __AuraFixUtil.card(p,
	    36)
	__AuraFixUtil.lbl(f,
	    text,
	    13,
	    nil,
	    {Position = UDim2.fromOffset(10,
	    0),
	    Size = UDim2.new(.34,
	    -10,
	    1,
	    0)})
	local seg = __AuraFixUtil.new("Frame",
	    {BackgroundColor3 = C.card2,
	    AnchorPoint = Vector2.new(1,
	    .5),
	    Position = UDim2.new(1,
	    -8,
	    .5,
	    0),
	    Size = UDim2.new(.66,
	    -12,
	    0,
	    24)},
	    f)
	__AuraFixUtil.round(seg,
	    6)
	local n = #opts
	local ind = __AuraFixUtil.new("Frame",
	    {Size = UDim2.new(1 / n,
	    -4,
	    1,
	    -4),
	    Position = UDim2.new(0,
	    2,
	    0,
	    2)},
	    seg)
	__AuraFixUtil.round(ind,
	    5); __AuraFixUtil.acc(ind,
	    "BackgroundColor3")
	local btns, cur = {}, 1
	local obj = {Default = originalDef}
	function obj.Set(i,
	    silent,
	    fast)
		i = math.clamp(math.floor(i + .5),
		    1,
		    n)
		cur = i
		if key then cfg[key] = i end
		local pos = UDim2.new((i - 1) / n,
		    2,
		    0,
		    2)
		if fast then ind.Position = pos else tw(ind,
		    {Position = pos},
		    .35,
		    EASE.Back) end
		for k, b in ipairs(btns) do
			local c = k == i and WHITE or C.sub
			if fast then b.TextColor3 = c else tw(b,
			    {TextColor3 = c},
			    .2) end
		end
		if not silent and cb then cb(i) end
	end
	for k, o in ipairs(opts) do
		local b = __AuraFixUtil.new("TextButton",
		    {Font = Enum.Font.GothamBold,
		    TextSize = n > 2 and 10 or 11,
		    TextColor3 = C.sub,
		    BackgroundTransparency = 1,
		    AutoButtonColor = false,
		    Position = UDim2.fromScale((k - 1) / n,
		    0),
		    Size = UDim2.fromScale(1 / n,
		    1),
		    ZIndex = 2},
		    seg)
		bind(b,
		    o)
		btns[k] = b
		cn(b.Activated,
		    function() if cur ~= k then obj.Set(k) end end)
		cn(b.MouseEnter,
		    function() tw(st,
		    {Transparency = .75},
		    .2) end)
		cn(b.MouseLeave,
		    function() tw(st,
		    {Transparency = .93},
		    .25) end)
	end
	local fromCfg = key and cfg[key] ~= nil
	obj.Set(fromCfg and cfg[key] or def or 1,
	    not fromCfg,
	    true)
	if key then ctl[key] = obj end
	return obj
end

__AuraFixUtil.TAB_STEP, __AuraFixUtil.TAB_H = 24, 22
local pages, order = {}, {"Музыка", "Эффекты", "Визуал", "RTX", "Игрок", "Бой", "Aura.Me", "Разное", "Настройки"}
function __AuraFixUtil.page(name)
	local p = __AuraFixUtil.new("ScrollingFrame",
	    {Name = name,
	    Size = UDim2.fromScale(1,
	    1),
	    BackgroundTransparency = 1,
	    ScrollBarThickness = 3,
	    CanvasSize = UDim2.new(),
	    AutomaticCanvasSize = Enum.AutomaticSize.Y,
	    ScrollingDirection = Enum.ScrollingDirection.Y,
	    Visible = false,
	    ScrollBarImageTransparency = .3},
	    content)
	__AuraFixUtil.new("UIListLayout",
	    {Padding = UDim.new(0,
	    6)},
	    p)
	__AuraFixUtil.new("UIPadding",
	    {PaddingRight = UDim.new(0,
	    6),
	    PaddingBottom = UDim.new(0,
	    6),
	    PaddingTop = UDim.new(0,
	    2)},
	    p)
	__AuraFixUtil.acc(p,
	    "ScrollBarImageColor3")
	pages[name] = p
	return p
end

function __AuraFixUtil.fmtT(s) s = math.floor(s); return string.format("%d:%02d",
    s // 60,
    s % 60) end

local sound = __AuraFixUtil.new("Sound",
    {Name = "AuraSound",
    Volume = 1},
    SoundService)
local pitch = __AuraFixUtil.new("PitchShiftSoundEffect",
    {Octave = 1,
    Enabled = false},
    sound)
local eq = __AuraFixUtil.new("EqualizerSoundEffect",
    {LowGain = 0,
    MidGain = 0,
    HighGain = 0},
    sound)
local reverb = __AuraFixUtil.new("ReverbSoundEffect",
    {Enabled = false,
    DecayTime = 2.8,
    DryLevel = -2,
    WetLevel = -4},
    sound)
local echo = __AuraFixUtil.new("EchoSoundEffect",
    {Enabled = false,
    Delay = .35,
    Feedback = .45,
    DryLevel = 0,
    WetLevel = -6},
    sound)

local S = {speed = 1,
    semi = 0,
    tape = true,
    db = 0}
function __AuraFixUtil.applyAudio()
	sound.PlaybackSpeed = S.speed
	local target = 2 ^ (S.semi / 12) * (S.tape and S.speed or 1)
	local oct = math.clamp(target / S.speed,
	    .5,
	    2)
	pitch.Octave = oct
	pitch.Enabled = math.abs(oct - 1) > .001
	sound.Volume = math.min(10 ^ (S.db / 20),
	    10)
end

local nameL, statusL, histBox, box, play
local history, playTok = {}, 0
local knownTitles = {}
local queueItems = {}
local queueList, queueStatus
local queueAutoPlay = true
local visualizerStyle = 1
local musicAccentPulse = true
local touched, trackOK, endedF = false, false, false
function __AuraFixUtil.setStatus(t,
    col)
	statusL.Text = t
	tw(statusL,
	    {TextColor3 = col or C.sub},
	    .25)
end
function __AuraFixUtil.idle()
	if touched then return end
	nameL.Text = T("Ничего не играет")
	__AuraFixUtil.setStatus(T("Введите ID и нажмите «Играть»"))
end

function __AuraFixUtil.addHistory(id)
	local i = table.find(history,
	    id); if i then table.remove(history,
	    i) end
	table.insert(history,
	    1,
	    id); if #history > 3 then table.remove(history) end
	for _, c in ipairs(histBox:GetChildren()) do if c:IsA("TextButton") then c:Destroy() end end
	for _, v in ipairs(history) do
		local b = __AuraFixUtil.new("TextButton",
		    {Text = v,
		    Font = Enum.Font.GothamMedium,
		    TextSize = 11,
		    TextColor3 = C.text,
		    AutoButtonColor = false,
		    BackgroundColor3 = C.card,
		    AutomaticSize = Enum.AutomaticSize.X,
		    Size = UDim2.new(0,
		    0,
		    1,
		    0)},
		    histBox)
		__AuraFixUtil.round(b,
		    6); __AuraFixUtil.press(b)
		__AuraFixUtil.stroke(b,
		    1,
		    WHITE,
		    .9)
		__AuraFixUtil.new("UIPadding",
		    {PaddingLeft = UDim.new(0,
		    8),
		    PaddingRight = UDim.new(0,
		    8)},
		    b)
		local sc = b:FindFirstChild("Pop")
		sc.Scale = .6
		tw(sc,
		    {Scale = 1},
		    .45,
		    EASE.Back)
		cn(b.Activated,
		    function() box.Text = v; play(v) end)
	end
	histBox.Visible = true
end

function play(raw)
	local id = tostring(raw or ""):match("%d+")
	if not id then __AuraFixUtil.setStatus(T("Введите числовой ID"),
	    C.bad) return end
	touched, trackOK, endedF = true, false, false
	playTok += 1
	local my = playTok
	sound:Stop()
	sound.SoundId = "rbxassetid://" .. id
	__AuraFixUtil.applyAudio()
	sound:Play()
	nameL.Text = id
	__AuraFixUtil.setStatus(T("Загрузка..."))
	local t0 = os.clock()
	while my == playTok and not sound.IsLoaded and os.clock() - t0 < 8 do task.wait(.1) end
	if my ~= playTok then return end
	if sound.IsLoaded and sound.TimeLength > 0 then
		local ok, info = pcall(function() return MPS:GetProductInfo(tonumber(id)) end)
		if my ~= playTok then return end
		nameL.Text = (ok and info and info.Name) or knownTitles[id] or id
		knownTitles[id] = nameL.Text
		trackOK = true
		__AuraFixUtil.toast("Трек загружен",
		    C.good)
		__AuraFixUtil.addHistory(id)
	else
		sound:Stop()
		nameL.Text = T("Ошибка")
		__AuraFixUtil.setStatus(T("Не загрузилось: ID закрыт или неверный"),
		    C.bad)
		__AuraFixUtil.toast("Не удалось загрузить ID",
		    C.bad)
	end
end

local V = {
	hl = true,
	    skel = false,
	    names = true,
	    dist = false,
	    range = 250,
	    style = 1,
	    fps = false,
	    box = true,
	    health = true,
	    tracers = false,
	    teamCheck = false,
	    healthText = false,
	    lineWidth = 1.5,
	    skelWidth = 1.5,
	    labelSize = 13,
	    brightness = 1,
}
local esp = {}
local espAny, espWas = true, false
do
    local Util = __AuraFixUtil
    local new = Util.new
    local kp = ColorSequenceKeypoint.new
    local nk = NumberSequenceKeypoint.new
    local DARK = Color3.fromRGB(10, 10, 16)
    local DIM = Color3.fromRGB(150, 150, 172)
    local PADT, PADB = 54, 14
    local R15 = {
        {"Head", "UpperTorso"}, {"UpperTorso", "LowerTorso"},
        {"UpperTorso", "LeftUpperArm"}, {"LeftUpperArm", "LeftLowerArm"}, {"LeftLowerArm", "LeftHand"},
        {"UpperTorso", "RightUpperArm"}, {"RightUpperArm", "RightLowerArm"}, {"RightLowerArm", "RightHand"},
        {"LowerTorso", "LeftUpperLeg"}, {"LeftUpperLeg", "LeftLowerLeg"}, {"LeftLowerLeg", "LeftFoot"},
        {"LowerTorso", "RightUpperLeg"}, {"RightUpperLeg", "RightLowerLeg"}, {"RightLowerLeg", "RightFoot"},
    }
    local R6 = {
        {"Head", "Torso"}, {"Torso", "Left Arm"}, {"Torso", "Right Arm"},
        {"Torso", "Left Leg"}, {"Torso", "Right Leg"},
    }
    local rayParams = RaycastParams.new()
    rayParams.FilterType = Enum.RaycastFilterType.Exclude
    local lastT = os.clock()

    V.corners = true
    V.arrows = true
    V.headDot = true
    V.visCheck = true

    function Util.refresh()
        espAny = V.hl or V.skel or V.names or V.dist or V.box or V.health or V.tracers or V.healthText or V.arrows or V.headDot
    end

    function Util.colorForHealth(x)
        x = math.clamp(x, 0, 1)
        if x > .5 then return C.warn:Lerp(C.good, (x - .5) * 2) end
        return C.bad:Lerp(C.warn, x * 2)
    end

    function Util.setLine(line, x1, y1, x2, y2, th)
        local dx, dy = x2 - x1, y2 - y1
        line.Position = UDim2.fromOffset((x1 + x2) * .5, (y1 + y2) * .5)
        line.Size = UDim2.fromOffset(math.sqrt(dx * dx + dy * dy), th)
        line.Rotation = math.deg(math.atan2(dy, dx))
    end

    function Util.getCharacterRoot(char)
        if not char then return nil end
        return char:FindFirstChild("HumanoidRootPart")
            or char:FindFirstChild("UpperTorso")
            or char:FindFirstChild("Torso")
            or char.PrimaryPart
    end

    local function frame(parent, props)
        if props.BackgroundTransparency == nil then props.BackgroundTransparency = 1 end
        return new("Frame", props, parent)
    end

    local function accGradient(stroke)
        return new("UIGradient", {Color = ColorSequence.new({kp(0, accent), kp(.5, Util.shift(accent)), kp(1, accent)})}, stroke)
    end

    function Util.attach(plr)
        if plr == lp or esp[plr] then return end
        local hl = new("Highlight", {Name = "AuraHL", DepthMode = Enum.HighlightDepthMode.AlwaysOnTop, Enabled = false, FillTransparency = 1, OutlineTransparency = 1}, workspace)
        local cv = new("CanvasGroup", {Name = "AuraESP", BackgroundTransparency = 1, Visible = false, GroupTransparency = 1}, skelLayer)
        local e = {hl = hl, cv = cv, a = 0, hp = 1, ph = math.random() * 6, bones = {}, lines = {}, brk = {}, vis = true, visT = 0, bt = 0, col = accent, shown = false}
        e.cvScale = new("UIScale", {Scale = .9}, cv)

        e.box = frame(cv, {Name = "Box"})
        Util.round(e.box, 4)
        e.boxStroke = Util.stroke(e.box, 1.5, accent, 0)
        e.boxGrad = accGradient(e.boxStroke)

        e.fill = frame(cv, {Name = "Fill", BackgroundTransparency = 0, BackgroundColor3 = accent})
        Util.round(e.fill, 4)
        new("UIGradient", {Rotation = 90, Transparency = NumberSequence.new({nk(0, .93), nk(1, .66)})}, e.fill)

        for i = 1, 4 do
            local ax = (i == 2 or i == 4) and 1 or 0
            local ay = i >= 3 and 1 or 0
            local h = frame(cv, {AnchorPoint = Vector2.new(ax, ay), BackgroundTransparency = 0, BackgroundColor3 = accent})
            local v = frame(cv, {AnchorPoint = Vector2.new(ax, ay), BackgroundTransparency = 0, BackgroundColor3 = accent})
            Util.round(h, 2)
            Util.round(v, 2)
            e.brk[i] = {h = h, v = v, ax = ax, ay = ay}
        end

        e.hb = frame(cv, {Name = "HealthBack", BackgroundTransparency = .22, BackgroundColor3 = DARK, Size = UDim2.fromOffset(4, 10)})
        Util.round(e.hb, 2)
        Util.stroke(e.hb, 1, Color3.new(0, 0, 0), .35)
        e.hf = frame(e.hb, {AnchorPoint = Vector2.new(0, 1), Position = UDim2.fromScale(0, 1), Size = UDim2.fromScale(1, 1), BackgroundTransparency = 0, BackgroundColor3 = C.good})
        Util.round(e.hf, 2)
        for q = 1, 3 do
            frame(e.hb, {Position = UDim2.fromScale(0, q / 4), Size = UDim2.new(1, 0, 0, 1), BackgroundTransparency = .3, BackgroundColor3 = Color3.new(0, 0, 0), ZIndex = 3})
        end

        e.tag = new("Frame", {Name = "Tag", AnchorPoint = Vector2.new(.5, 1), AutomaticSize = Enum.AutomaticSize.XY, Size = UDim2.fromOffset(0, 0), BackgroundColor3 = C.bar, BackgroundTransparency = .1, Visible = false}, cv)
        Util.round(e.tag, 7)
        e.tagStroke = Util.stroke(e.tag, 1.2, accent, .2)
        e.tagGrad = accGradient(e.tagStroke)
        e.tagScale = new("UIScale", {}, e.tag)
        new("UIPadding", {PaddingLeft = UDim.new(0, 9), PaddingRight = UDim.new(0, 9), PaddingTop = UDim.new(0, 4), PaddingBottom = UDim.new(0, 4)}, e.tag)
        new("UIListLayout", {HorizontalAlignment = Enum.HorizontalAlignment.Center, Padding = UDim.new(0, 1)}, e.tag)
        e.nameL = new("TextLabel", {BackgroundTransparency = 1, AutomaticSize = Enum.AutomaticSize.X, Size = UDim2.fromOffset(0, 16), Font = Enum.Font.GothamBold, TextSize = 13, TextColor3 = C.text, Text = "", TextXAlignment = Enum.TextXAlignment.Center}, e.tag)
        e.infoL = new("TextLabel", {BackgroundTransparency = 1, AutomaticSize = Enum.AutomaticSize.X, Size = UDim2.fromOffset(0, 13), Font = Enum.Font.GothamMedium, TextSize = 11, TextColor3 = C.sub, Text = "", RichText = true, TextXAlignment = Enum.TextXAlignment.Center}, e.tag)

        e.head = frame(cv, {AnchorPoint = Vector2.new(.5, .5), Size = UDim2.fromOffset(10, 10)})
        Util.round(e.head, 30)
        e.headStroke = Util.stroke(e.head, 1.5, accent, .1)

        e.tracer = new("Frame", {AnchorPoint = Vector2.new(.5, .5), BackgroundColor3 = accent, BackgroundTransparency = .2, Visible = false}, skelLayer)
        new("UIGradient", {Transparency = NumberSequence.new({nk(0, .9), nk(1, 0)})}, e.tracer)
        e.tdot = new("Frame", {AnchorPoint = Vector2.new(.5, .5), Size = UDim2.fromOffset(6, 6), BackgroundColor3 = accent, Visible = false}, skelLayer)
        Util.round(e.tdot, 6)

        e.arrow = new("TextLabel", {AnchorPoint = Vector2.new(.5, .5), Size = UDim2.fromOffset(24, 24), BackgroundTransparency = 1, Text = "▲", Font = Enum.Font.GothamBlack, TextSize = 20, TextColor3 = accent, TextStrokeTransparency = .55, Visible = false}, skelLayer)
        e.arrowD = new("TextLabel", {AnchorPoint = Vector2.new(.5, .5), Size = UDim2.fromOffset(54, 14), BackgroundTransparency = 1, Text = "", Font = Enum.Font.GothamBold, TextSize = 10, TextColor3 = C.text, TextStrokeTransparency = .4, Visible = false}, skelLayer)
        esp[plr] = e
    end

    function Util.detach(plr)
        local e = esp[plr]
        if not e then return end
        for _, o in ipairs({e.hl, e.cv, e.tracer, e.tdot, e.arrow, e.arrowD}) do
            if o then pcall(function() o:Destroy() end) end
        end
        for _, l in ipairs(e.lines) do pcall(function() l:Destroy() end) end
        esp[plr] = nil
    end

    local function hideAll(e)
        e.cv.Visible = false
        e.tracer.Visible = false
        e.tdot.Visible = false
        e.arrow.Visible = false
        e.arrowD.Visible = false
        for _, l in ipairs(e.lines) do l.Visible = false end
        if e.hl.Enabled then e.hl.Enabled = false end
        e.shown = false
    end

    local function buildBones(e, char, t)
        e.bones = {}
        local list = char:FindFirstChild("UpperTorso") and R15 or R6
        for _, pr in ipairs(list) do
            local a, b = char:FindFirstChild(pr[1]), char:FindFirstChild(pr[2])
            if a and b then e.bones[#e.bones + 1] = {a, b} end
        end
        e.bchar, e.bt = char, t
        while #e.lines < #e.bones do
            local l = new("Frame", {AnchorPoint = Vector2.new(.5, .5), BackgroundColor3 = accent, Visible = false}, skelLayer)
            Util.round(l, 2)
            e.lines[#e.lines + 1] = l
        end
    end

    local function pickColor(e, k)
        local target = e.vis and accent or accent:Lerp(DIM, .55)
        e.col = e.col:Lerp(target, k)
        return e.col
    end

    function Util.updateESP(t)
        local now = os.clock()
        local dt = math.clamp(now - lastT, 0, .1)
        lastT = now
        local cam = workspace.CurrentCamera
        if not cam then return end
        local vs = cam.ViewportSize
        local camPos = cam.CFrame.Position
        local myRoot = Util.getCharacterRoot(lp.Character)
        local origin = myRoot and myRoot.Position or camPos
        local k = 1 - math.exp(-dt * 16)
        local ka = 1 - math.exp(-dt * 9)
        local bright = math.clamp(V.brightness or 1, .2, 1)
        local lw = V.lineWidth or 1.5
        local anyCv = V.box or V.health or V.names or V.dist or V.healthText or V.headDot
        for plr, e in pairs(esp) do
            local char = plr.Character
            local hrp = Util.getCharacterRoot(char)
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if not (hrp and hum) then
                if e.shown then hideAll(e) end
                e.a = 0
                continue
            end
            local d = (hrp.Position - origin).Magnitude
            local sameTeam = V.teamCheck and lp.Team ~= nil and plr.Team ~= nil and lp.Team == plr.Team
            local alive = hum.Health > 0 and d <= V.range and not sameTeam
            e.a += ((alive and 1 or 0) - e.a) * ka
            if e.a < .02 and not alive then
                if e.shown then hideAll(e) end
                continue
            end
            e.shown = true

            if e.char ~= char then
                e.char = char
                e.hl.Adornee = char
                e.bchar = nil
                e.fresh = true
            end

            local head = char:FindFirstChild("Head")
            local headPos = head and head.Position or hrp.Position + Vector3.new(0, 1.5, 0)
            e.visT -= dt
            if e.visT <= 0 then
                e.visT = .12 + math.random() * .06
                if V.visCheck then
                    local ignore = {char}
                    if lp.Character then ignore[2] = lp.Character end
                    rayParams.FilterDescendantsInstances = ignore
                    e.vis = workspace:Raycast(camPos, headPos - camPos, rayParams) == nil
                else
                    e.vis = true
                end
            end
            local col = pickColor(e, k)

            local showHl = V.hl and e.a > .02
            if showHl then
                e.hl.Enabled = true
                local pulse = (math.sin(t * 2.4 + e.ph) + 1) / 2
                if V.style == 1 then
                    e.hl.FillColor, e.hl.OutlineColor = col, col
                    e.hl.FillTransparency = 1
                    e.hl.OutlineTransparency = 1 - e.a * (.35 + .65 * bright)
                elseif V.style == 2 then
                    e.hl.FillColor, e.hl.OutlineColor = col, WHITE
                    e.hl.FillTransparency = 1 - e.a * .55 * bright
                    e.hl.OutlineTransparency = .2 + (1 - e.a) * .8
                else
                    e.hl.FillColor = col:Lerp(Util.shift(col), pulse)
                    e.hl.OutlineColor = Util.shift(col):Lerp(col, pulse)
                    e.hl.FillTransparency = 1 - e.a * (.35 + pulse * .2)
                    e.hl.OutlineTransparency = .1 + (1 - e.a) * .9
                end
            elseif e.hl.Enabled then
                e.hl.Enabled = false
            end

            local pc = cam:WorldToViewportPoint(hrp.Position)
            local onScreen = pc.Z > 0 and pc.X >= -20 and pc.X <= vs.X + 20 and pc.Y >= -20 and pc.Y <= vs.Y + 20

            local feetOff = hum.RigType == Enum.HumanoidRigType.R15 and (hrp.Size.Y / 2 + hum.HipHeight) or 3
            local topW = headPos + Vector3.new(0, (head and head.Size.Y / 2 or 0) + .2, 0)
            local botW = hrp.Position - Vector3.new(0, feetOff + .1, 0)
            local pt, pb = cam:WorldToViewportPoint(topW), cam:WorldToViewportPoint(botW)
            local rectOK = onScreen and pt.Z > 0 and pb.Z > 0

            if rectOK and anyCv then
                local h = math.max(pb.Y - pt.Y, 8)
                local w = h * .52
                local cx = (pt.X + pb.X) * .5
                if e.fresh or not e.cx then
                    e.cx, e.top, e.w, e.h = cx, pt.Y, w, h
                    e.fresh = false
                else
                    e.cx += (cx - e.cx) * k
                    e.top += (pt.Y - e.top) * k
                    e.w += (w - e.w) * k
                    e.h += (h - e.h) * k
                end
                local W, H = e.w, e.h
                local cw = math.max(W + 52, 200)
                local ch = H + PADT + PADB
                local ox = math.floor(e.cx - cw / 2 + .5)
                local oy = math.floor(e.top - PADT + .5)
                e.cv.Position = UDim2.fromOffset(ox, oy)
                e.cv.Size = UDim2.fromOffset(cw, ch)
                e.cv.GroupTransparency = 1 - e.a * bright
                e.cvScale.Scale = .9 + .1 * e.a
                e.cv.Visible = true
                local bx0, by0 = (cw - W) / 2, PADT
                local bx1, by1 = bx0 + W, by0 + H

                local boxOn = V.box
                e.box.Visible = boxOn and not V.corners
                e.fill.Visible = boxOn and V.style >= 2
                if e.box.Visible then
                    e.box.Position = UDim2.fromOffset(bx0, by0)
                    e.box.Size = UDim2.fromOffset(W, H)
                    e.boxStroke.Thickness = lw
                end
                e.boxGrad.Rotation = (t * 70) % 360
                e.tagGrad.Rotation = (t * 70) % 360
                if e.lastAcc ~= accent then
                    e.lastAcc = accent
                    e.boxGrad.Color = ColorSequence.new({kp(0, accent), kp(.5, Util.shift(accent)), kp(1, accent)})
                    e.tagGrad.Color = e.boxGrad.Color
                end
                if e.fill.Visible then
                    e.fill.Position = UDim2.fromOffset(bx0, by0)
                    e.fill.Size = UDim2.fromOffset(W, H)
                    e.fill.BackgroundColor3 = col
                end
                local cornersOn = boxOn and V.corners
                local L = math.clamp(W * .3, 7, 26)
                local th = lw + .5
                for i = 1, 4 do
                    local b = e.brk[i]
                    b.h.Visible, b.v.Visible = cornersOn, cornersOn
                    if cornersOn then
                        local px = b.ax == 1 and bx1 or bx0
                        local py = b.ay == 1 and by1 or by0
                        b.h.Position = UDim2.fromOffset(px, py)
                        b.v.Position = UDim2.fromOffset(px, py)
                        b.h.Size = UDim2.fromOffset(L, th)
                        b.v.Size = UDim2.fromOffset(th, L)
                        b.h.BackgroundColor3, b.v.BackgroundColor3 = col, col
                    end
                end

                if V.health then
                    local real = math.clamp(hum.Health / math.max(hum.MaxHealth, 1), 0, 1)
                    e.hp += (real - e.hp) * k
                    e.hb.Visible = true
                    e.hb.Position = UDim2.fromOffset(bx0 - 8, by0)
                    e.hb.Size = UDim2.fromOffset(4, H)
                    e.hf.Size = UDim2.fromScale(1, math.max(e.hp, .02))
                    local hc = Util.colorForHealth(e.hp)
                    if e.hp < .3 then hc = hc:Lerp(WHITE, (math.sin(t * 9) + 1) * .15) end
                    e.hf.BackgroundColor3 = hc
                else
                    e.hb.Visible = false
                end

                if V.headDot and head then
                    local hp2 = cam:WorldToViewportPoint(headPos)
                    if hp2.Z > 0 then
                        local sz = math.clamp(H * .16, 6, 34)
                        e.head.Visible = true
                        e.head.Size = UDim2.fromOffset(sz, sz)
                        e.head.Position = UDim2.fromOffset(hp2.X - ox, hp2.Y - oy)
                        e.headStroke.Color = col
                    else
                        e.head.Visible = false
                    end
                else
                    e.head.Visible = false
                end

                local showName, showInfo = V.names, V.dist or V.healthText
                if showName or showInfo then
                    e.tag.Visible = true
                    e.tag.Position = UDim2.fromOffset(cw / 2, PADT - 6)
                    e.tagScale.Scale = math.clamp(1.06 - d / math.max(V.range, 1) * .38, .64, 1.06)
                    e.tagStroke.Color = col
                    e.nameL.Visible = showName
                    e.nameL.TextSize = V.labelSize
                    e.nameL.Size = UDim2.fromOffset(0, V.labelSize + 3)
                    if showName and e.nameL.Text ~= plr.DisplayName then e.nameL.Text = plr.DisplayName end
                    e.infoL.Visible = showInfo
                    e.infoL.TextSize = math.max(V.labelSize - 2, 8)
                    e.infoL.Size = UDim2.fromOffset(0, math.max(V.labelSize - 2, 8) + 3)
                    if showInfo then
                        local parts = {}
                        if V.dist then parts[#parts + 1] = string.format("%d %s", math.floor(d), T("ст.")) end
                        if V.healthText then
                            local pct = math.floor(math.clamp(hum.Health / math.max(hum.MaxHealth, 1), 0, 1) * 100)
                            parts[#parts + 1] = string.format("<font color=\"#%s\">%d%%</font>", Util.colorForHealth(pct / 100):ToHex(), pct)
                        end
                        local s = table.concat(parts, "  ·  ")
                        if e.infoL.Text ~= s then e.infoL.Text = s end
                    end
                else
                    e.tag.Visible = false
                end
            else
                e.cv.Visible = false
                e.fresh = true
            end

            local tcol = col
            if V.tracers and rectOK then
                e.tracer.Visible, e.tdot.Visible = true, true
                Util.setLine(e.tracer, vs.X / 2, vs.Y - 2, pb.X, pb.Y, math.max(lw * .7, 1))
                e.tracer.BackgroundColor3, e.tdot.BackgroundColor3 = tcol, tcol
                e.tracer.BackgroundTransparency = 1 - .85 * e.a * bright
                e.tdot.BackgroundTransparency = 1 - e.a * bright
                e.tdot.Position = UDim2.fromOffset(pb.X, pb.Y)
            else
                e.tracer.Visible, e.tdot.Visible = false, false
            end

            if V.skel and e.a > .02 then
                if e.bchar ~= char or t - e.bt > 2 then buildBones(e, char, t) end
                for i, bone in ipairs(e.bones) do
                    local line = e.lines[i]
                    local a, b = bone[1], bone[2]
                    if a.Parent and b.Parent then
                        local p1, p2 = cam:WorldToViewportPoint(a.Position), cam:WorldToViewportPoint(b.Position)
                        if p1.Z > 0 and p2.Z > 0 then
                            line.Visible = true
                            Util.setLine(line, p1.X, p1.Y, p2.X, p2.Y, V.skelWidth)
                            line.BackgroundColor3 = col
                            line.BackgroundTransparency = 1 - .9 * e.a * bright
                        else
                            line.Visible = false
                        end
                    else
                        line.Visible = false
                    end
                end
                for i = #e.bones + 1, #e.lines do e.lines[i].Visible = false end
            else
                for _, l in ipairs(e.lines) do l.Visible = false end
            end

            if V.arrows and alive and not onScreen then
                local sx, sy = pc.X, pc.Y
                if pc.Z < 0 then sx, sy = vs.X - sx, vs.Y - sy end
                local dx, dy = sx - vs.X / 2, sy - vs.Y / 2
                if dx == 0 and dy == 0 then dy = 1 end
                local ang = math.atan2(dy, dx)
                local px = vs.X / 2 + math.cos(ang) * vs.X * .44
                local py = vs.Y / 2 + math.sin(ang) * vs.Y * .42
                local beat = 1 + math.sin(t * 5 + e.ph) * .08
                e.arrow.Visible, e.arrowD.Visible = true, true
                e.arrow.Position = UDim2.fromOffset(px, py)
                e.arrow.Rotation = math.deg(ang) + 90
                e.arrow.Size = UDim2.fromOffset(24 * beat, 24 * beat)
                e.arrow.TextColor3 = col
                e.arrow.TextTransparency = 1 - e.a * bright
                e.arrowD.Position = UDim2.fromOffset(px - math.cos(ang) * 22, py - math.sin(ang) * 22)
                e.arrowD.Text = string.format("%d", math.floor(d))
                e.arrowD.TextTransparency = 1 - e.a * bright
            else
                e.arrow.Visible, e.arrowD.Visible = false, false
            end
        end
    end
end
for _, p in ipairs(Players:GetPlayers()) do __AuraFixUtil.attach(p) end
cn(Players.PlayerAdded,
    __AuraFixUtil.attach)
cn(Players.PlayerRemoving,
    __AuraFixUtil.detach)

local afkOn, rejoinOn, rejoining = true, false, false
local fovT, fovOn = 70, false
cn(lp.Idled,
    function()
	if afkOn and okVU and VU then
		pcall(function() VU:CaptureController(); VU:ClickButton2(Vector2.new()) end)
	end
end)
function __AuraFixUtil.rejoin()
	if not rejoinOn or rejoining then return end
	rejoining = true
	__AuraFixUtil.toast("Переподключение...")
	task.wait(1)
	local ok = pcall(function() TeleportService:TeleportToPlaceInstance(game.PlaceId,
	    game.JobId,
	    lp) end)
	if not ok then pcall(function() TeleportService:Teleport(game.PlaceId,
	    lp) end) end
	task.delay(8,
	    function() rejoining = false end)
end
cn(GuiService.ErrorMessageChanged,
    function()
	local ok, m = pcall(function() return GuiService:GetErrorMessage() end)
	if rejoinOn and (not ok or m ~= "") then task.spawn(__AuraFixUtil.rejoin) end
end)
cn(TeleportService.TeleportInitFailed,
    function()
	if rejoinOn then task.delay(2,
	    function() pcall(function() TeleportService:Teleport(game.PlaceId,
	    lp) end) end) end
end)

local fpsAura = __AuraFixUtil.new("Frame",
    {Size = UDim2.fromOffset(120,
    34),
    Position = UDim2.new(1,
    -126,
    0,
    6),
    BackgroundColor3 = accent,
    BackgroundTransparency = 1,
    Visible = false,
    ZIndex = 14},
    gui)
__AuraFixUtil.round(fpsAura,
    17)
local fpsAuraScale = __AuraFixUtil.new("UIScale",
    {Scale = .88},
    fpsAura)
local fpsF = __AuraFixUtil.new("Frame",
    {Size = UDim2.fromOffset(112,
    26),
    Position = UDim2.new(1,
    -122,
    0,
    10),
    BackgroundColor3 = C.bar,
    Visible = false,
    ZIndex = 15},
    gui)
__AuraFixUtil.round(fpsF,
    13)
local fpsStroke = __AuraFixUtil.stroke(fpsF,
    1.2,
    accent,
    .38)
local fpsGradient = __AuraFixUtil.new("UIGradient",
    {Rotation = 0,
    Color = ColorSequence.new({ColorSequenceKeypoint.new(0,
    C.bar),
    ColorSequenceKeypoint.new(.5,
    C.card2),
    ColorSequenceKeypoint.new(1,
    C.bar)}),
    Offset = Vector2.new(-1,
    0)},
    fpsF)
__AuraFixUtil.loop(fpsGradient,
    {Offset = Vector2.new(1,
    0)},
    2.7)
local fpsS = __AuraFixUtil.new("UIScale",
    {Scale = .01},
    fpsF)
local fpsD = __AuraFixUtil.new("Frame",
    {AnchorPoint = Vector2.new(0,
    .5),
    Position = UDim2.new(0,
    10,
    .5,
    0),
    Size = UDim2.fromOffset(8,
    8),
    BackgroundColor3 = C.good,
    ZIndex = 16},
    fpsF)
__AuraFixUtil.round(fpsD,
    4)
local fpsL = __AuraFixUtil.new("TextLabel",
    {BackgroundTransparency = 1,
    Position = UDim2.fromOffset(24,
    0),
    Size = UDim2.new(1,
    -28,
    1,
    0),
    Font = Enum.Font.GothamBold,
    TextSize = 12,
    TextColor3 = C.text,
    TextXAlignment = Enum.TextXAlignment.Left,
    Text = "",
    ZIndex = 16},
    fpsF)
__AuraFixUtil.drag(fpsF,
    fpsF,
    function(W,
    H) return 0,
    W - 112,
    0,
    H - 26 end)
cn(fpsF:GetPropertyChangedSignal("Position"),
    function()
	fpsAura.Position = UDim2.new(fpsF.Position.X.Scale,
	    fpsF.Position.X.Offset - 4,
	    fpsF.Position.Y.Scale,
	    fpsF.Position.Y.Offset - 4)
end)
function __AuraFixUtil.showFps(v)
	if v then
		fpsAura.Visible = true
		fpsF.Visible = true
		fpsAura.BackgroundTransparency = 1
		fpsAuraScale.Scale = .88
		fpsS.Scale = .78
		tw(fpsAura,
		    {BackgroundTransparency = .72},
		    .42,
		    EASE.Sine)
		tw(fpsAuraScale,
		    {Scale = 1},
		    .48,
		    EASE.Back)
		tw(fpsS,
		    {Scale = 1},
		    .48,
		    EASE.Back)
	else
		tw(fpsAura,
		    {BackgroundTransparency = 1},
		    .28,
		    EASE.Sine)
		tw(fpsAuraScale,
		    {Scale = .88},
		    .28,
		    EASE.Quint,
		    DIR.In)
		tw(fpsS,
		    {Scale = .01},
		    .28,
		    EASE.Quint,
		    DIR.In)
		task.delay(.31,
		    function() if not V.fps then fpsF.Visible = false; fpsAura.Visible = false end end)
	end
end
local fpsA, fpsN = 0, 0

local envCleanup
function __AuraFixUtil.unload()
	pcall(function() RS:UnbindFromRenderStep("AuraMenuLoop") end)
	if __AuraFix_activeTweens then for _, records in pairs(__AuraFix_activeTweens) do for _, record in ipairs(records) do pcall(function() record.tween:Cancel() end) end end; table.clear(__AuraFix_activeTweens) end
	for _, c in ipairs(conns) do pcall(function() c:Disconnect() end) end
	for plr in pairs(esp) do __AuraFixUtil.detach(plr) end
	if __AuraFixUtil.extraCleanup then pcall(__AuraFixUtil.extraCleanup) end
    for _, object in ipairs({blur,
        sound,
        gui,
        __AuraFix_envBloom,
        __AuraFix_envColor,
        __AuraFix_envRays,
        __AuraFix_envDOF}) do
        if object and object.Parent then pcall(function() object:Destroy() end) end
    end
    if envCleanup then pcall(envCleanup) end
    if __AuraFix_ambientFolder and __AuraFix_ambientFolder.Parent then pcall(function() __AuraFix_ambientFolder:Destroy() end) end
    genv.AuraUnload = nil
end
genv.AuraUnload = __AuraFixUtil.unload

local spd, tapeT, semi, vol, bassS, midS, trebS, reverbT, echoT, prog, pauseB, reverbDecayS, reverbWetS, echoDelayS, echoFeedbackS
function __AuraFixUtil.resetAll()
	spd.Set(1); tapeT.Set(true); semi.Set(0); vol.Set(0)
	bassS.Set(0); midS.Set(0); trebS.Set(0); reverbT.Set(false); echoT.Set(false)
    reverb.DecayTime = 2.8; reverb.WetLevel = -4; echo.Delay = .35; echo.Feedback = .45; echo.WetLevel = -6
    if reverbDecayS then reverbDecayS.Set(2.8) end; if reverbWetS then reverbWetS.Set(-4) end
    if echoDelayS then echoDelayS.Set(.35) end; if echoFeedbackS then echoFeedbackS.Set(.45) end
end
function __AuraFixUtil.dbfmt(v) return string.format("%+.0f dB",
    v) end

__AuraFix_pg = __AuraFixUtil.page("Музыка")
__AuraFixUtil.section(__AuraFix_pg,
    "ПЛЕЕР")
__AuraFix_idc = __AuraFixUtil.card(__AuraFix_pg,
    42)
box = __AuraFixUtil.new("TextBox",
    {Text = "",
    ClearTextOnFocus = false,
    Font = Enum.Font.GothamMedium,
    TextSize = 13,
    TextColor3 = C.text,
    PlaceholderColor3 = C.sub,
    BackgroundColor3 = C.card2,
    TextXAlignment = Enum.TextXAlignment.Left,
    ClipsDescendants = true,
    Position = UDim2.fromOffset(6,
    6),
    Size = UDim2.new(1,
    -94,
    1,
    -12)},
    __AuraFix_idc)
bind(box,
    "Вставьте ID песни",
    "PlaceholderText")
__AuraFixUtil.round(box,
    6); __AuraFixUtil.new("UIPadding",
    {PaddingLeft = UDim.new(0,
    8)},
    box)
__AuraFix_bs = __AuraFixUtil.stroke(box,
    1.5,
    accent,
    1); __AuraFixUtil.acc(__AuraFix_bs,
    "Color")
cn(box.Focused,
    function() tw(__AuraFix_bs,
    {Transparency = 0},
    .2) end)
cn(box.FocusLost,
    function(enter)
	tw(__AuraFix_bs,
	    {Transparency = 1},
	    .25)
	box.Text = box.Text:match("%d+") or ""
	if enter then play(box.Text) end
end)
cn(box:GetPropertyChangedSignal("Text"),
    function()
	local s = box.Text:match("%d+") or ""
	if s ~= box.Text then box.Text = s end
end)
__AuraFix_go = __AuraFixUtil.button(__AuraFix_idc,
    "Играть",
    function() play(box.Text) end,
    true,
    UDim2.new(0,
    76,
    1,
    -12))
__AuraFix_go.Position = UDim2.new(1,
    -82,
    0,
    6)

__AuraFix_np = __AuraFixUtil.card(__AuraFix_pg,
    60)
__AuraFix_vinyl = __AuraFixUtil.new("Frame",
    {AnchorPoint = Vector2.new(0,
    .5),
    Position = UDim2.new(0,
    10,
    .5,
    0),
    Size = UDim2.fromOffset(44,
    44),
    BackgroundColor3 = WHITE},
    __AuraFix_np)
__AuraFixUtil.round(__AuraFix_vinyl,
    22)
__AuraFix_vs = __AuraFixUtil.stroke(__AuraFix_vinyl,
    2,
    accent,
    .4); __AuraFixUtil.acc(__AuraFix_vs,
    "Color")
__AuraFix_hi, __AuraFix_lo2 = Color3.fromRGB(95,
    95,
    118), Color3.fromRGB(22,
    22,
    30)
__AuraFixUtil.new("UIGradient",
    {Rotation = 35,
    Color = ColorSequence.new({ColorSequenceKeypoint.new(0,
    __AuraFix_hi),
    ColorSequenceKeypoint.new(.25,
    __AuraFix_lo2),
    ColorSequenceKeypoint.new(.5,
    __AuraFix_hi),
    ColorSequenceKeypoint.new(.75,
    __AuraFix_lo2),
    ColorSequenceKeypoint.new(1,
    __AuraFix_hi)})},
    __AuraFix_vinyl)
for _, d in ipairs({36,
    28}) do
	local g = __AuraFixUtil.new("Frame",
	    {AnchorPoint = Vector2.new(.5,
	    .5),
	    Position = UDim2.fromScale(.5,
	    .5),
	    Size = UDim2.fromOffset(d,
	    d),
	    BackgroundTransparency = 1},
	    __AuraFix_vinyl)
	__AuraFixUtil.round(g,
	    d / 2); __AuraFixUtil.stroke(g,
	    1,
	    WHITE,
	    .88)
end
__AuraFix_vlab = __AuraFixUtil.new("Frame",
    {AnchorPoint = Vector2.new(.5,
    .5),
    Position = UDim2.fromScale(.5,
    .5),
    Size = UDim2.fromOffset(16,
    16)},
    __AuraFix_vinyl)
__AuraFixUtil.round(__AuraFix_vlab,
    8); __AuraFixUtil.acc(__AuraFix_vlab,
    "BackgroundColor3")
__AuraFix_vhole = __AuraFixUtil.new("Frame",
    {AnchorPoint = Vector2.new(.5,
    .5),
    Position = UDim2.fromScale(.5,
    .5),
    Size = UDim2.fromOffset(4,
    4),
    BackgroundColor3 = C.card},
    __AuraFix_vlab)
__AuraFixUtil.round(__AuraFix_vhole,
    2)
nameL = __AuraFixUtil.lbl(__AuraFix_np,
    "",
    13,
    nil,
    {Position = UDim2.fromOffset(64,
    10),
    Size = UDim2.new(1,
    -74,
    0,
    18),
    Font = Enum.Font.GothamBold})
statusL = __AuraFixUtil.lbl(__AuraFix_np,
    "",
    11,
    C.sub,
    {Position = UDim2.fromOffset(64,
    30),
    Size = UDim2.new(1,
    -74,
    0,
    16)})
trReg[#trReg + 1] = __AuraFixUtil.idle
__AuraFixUtil.idle()

histBox = __AuraFixUtil.new("Frame",
    {Size = UDim2.new(1,
    0,
    0,
    26),
    BackgroundTransparency = 1,
    Visible = false},
    __AuraFix_pg)
__AuraFixUtil.new("UIListLayout",
    {FillDirection = Enum.FillDirection.Horizontal,
    Padding = UDim.new(0,
    5)},
    histBox)

__AuraFix_queueHeading = __AuraFixUtil.section(__AuraFix_pg,
    "ОЧЕРЕДЬ")
__AuraFix_queueInfo = __AuraFixUtil.card(__AuraFix_pg,
    30)
queueStatus = __AuraFixUtil.lbl(__AuraFix_queueInfo,
    "Очередь пуста",
    11,
    C.sub,
    {Position = UDim2.fromOffset(10,
    0),
    Size = UDim2.new(1,
    -96,
    1,
    0)})
__AuraFix_clearQueueButton = __AuraFixUtil.button(__AuraFix_queueInfo,
    "Очистить очередь",
    function()
	table.clear(queueItems)
	if queueList then
		for _, child in ipairs(queueList:GetChildren()) do
			if not child:IsA("UIListLayout") then child:Destroy() end
		end
	end
	queueStatus.Text = T("Очередь пуста")
	__AuraFixUtil.toast("Список очищен")
end,
    false,
    UDim2.new(0,
    90,
    1,
    -8))
__AuraFix_clearQueueButton.Position = UDim2.new(1,
    -94,
    0,
    4)
queueList = __AuraFixUtil.new("Frame",
    {Size = UDim2.new(1,
    0,
    0,
    0),
    AutomaticSize = Enum.AutomaticSize.Y,
    BackgroundTransparency = 1},
    __AuraFix_pg)
__AuraFixUtil.new("UIListLayout",
    {Padding = UDim.new(0,
    4),
    SortOrder = Enum.SortOrder.LayoutOrder},
    queueList)

function __AuraFix_clearGenerated(parent)
	for _, child in ipairs(parent:GetChildren()) do
		if not child:IsA("UIListLayout") and not child:IsA("UIPadding") then child:Destroy() end
	end
end

function __AuraFix_renderQueue()
	if not queueList then return end
	__AuraFix_clearGenerated(queueList)
	local count = #queueItems
	queueStatus.Text = count > 0 and (T("В очереди") .. ": " .. tostring(count)) or T("Очередь пуста")
	if count == 0 then
		local empty = __AuraFixUtil.new("Frame",
		    {Size = UDim2.new(1,
		    0,
		    0,
		    28),
		    BackgroundColor3 = C.card3,
		    BackgroundTransparency = .2},
		    queueList)
		__AuraFixUtil.round(empty,
		    7)
		__AuraFixUtil.lbl(empty,
		    T("Очередь пуста"),
		    11,
		    C.sub,
		    {Position = UDim2.fromOffset(10,
		    0),
		    Size = UDim2.new(1,
		    -20,
		    1,
		    0)})
		return
	end
	for index, item in ipairs(queueItems) do
		local rowFrame = __AuraFixUtil.new("Frame",
		    {Size = UDim2.new(1,
		    0,
		    0,
		    36),
		    BackgroundColor3 = C.card,
		    BackgroundTransparency = .05},
		    queueList)
		__AuraFixUtil.round(rowFrame,
		    7)
		local countLabel = __AuraFixUtil.new("TextLabel",
		    {BackgroundColor3 = C.card2,
		    Position = UDim2.fromOffset(5,
		    5),
		    Size = UDim2.fromOffset(26,
		    26),
		    Font = Enum.Font.GothamBold,
		    TextSize = 11,
		    TextColor3 = accent,
		    Text = string.format("%02d",
		    index)},
		    rowFrame)
		__AuraFixUtil.round(countLabel,
		    6)
		local titleLabel = __AuraFixUtil.lbl(rowFrame,
		    item.title or item.id,
		    11,
		    C.text,
		    {Position = UDim2.fromOffset(38,
		    1),
		    Size = UDim2.new(1,
		    -116,
		    1,
		    -2),
		    Font = Enum.Font.GothamMedium})
		local playNow = __AuraFixUtil.new("TextButton",
		    {Text = "▶",
		    Font = Enum.Font.GothamBold,
		    TextSize = 12,
		    TextColor3 = WHITE,
		    AutoButtonColor = false,
		    BackgroundColor3 = accent,
		    AnchorPoint = Vector2.new(1,
		    .5),
		    Position = UDim2.new(1,
		    -40,
		    .5,
		    0),
		    Size = UDim2.fromOffset(30,
		    26)},
		    rowFrame)
		__AuraFixUtil.round(playNow,
		    6)
		__AuraFixUtil.press(playNow,
		    true)
		cn(playNow.Activated,
		    function()
			table.remove(queueItems,
			    index)
			__AuraFix_renderQueue()
			box.Text = item.id
			play(item.id)
		end)
		local remove = __AuraFixUtil.new("TextButton",
		    {Text = "×",
		    Font = Enum.Font.GothamBold,
		    TextSize = 16,
		    TextColor3 = C.sub,
		    AutoButtonColor = false,
		    BackgroundColor3 = C.card2,
		    AnchorPoint = Vector2.new(1,
		    .5),
		    Position = UDim2.new(1,
		    -6,
		    .5,
		    0),
		    Size = UDim2.fromOffset(28,
		    26)},
		    rowFrame)
		__AuraFixUtil.round(remove,
		    6)
		__AuraFixUtil.press(remove,
		    true)
		cn(remove.Activated,
		    function()
			table.remove(queueItems,
			    index)
			__AuraFix_renderQueue()
		end)
		cn(rowFrame.MouseEnter,
		    function() tw(rowFrame,
		    {BackgroundColor3 = C.card2},
		    .15) end)
		cn(rowFrame.MouseLeave,
		    function() tw(rowFrame,
		    {BackgroundColor3 = C.card},
		    .2) end)
	end
end

function __AuraFix_addToQueue(id,
    title,
    artist)
	id = tostring(id or "")
	if not id:match("^%d+$") then return end
	for _, item in ipairs(queueItems) do
		if item.id == id then
			__AuraFixUtil.toast("Уже в очереди",
			    C.warn)
			return
		end
	end
	table.insert(queueItems,
	    {id = id,
	    title = title or knownTitles[id] or id,
	    artist = artist})
	__AuraFix_renderQueue()
	__AuraFixUtil.toast("Добавлено в очередь",
	    C.good)
end

__AuraFix_renderQueue()

-- The redundant floating mini-player has been removed; playback stays inside the Music tab.
__AuraFix_vc = __AuraFixUtil.card(__AuraFix_pg,
    56)
__AuraFix_bars = {}
for n = 1, 28 do
	local b = __AuraFixUtil.new("Frame",
	    {BackgroundColor3 = WHITE,
	    AnchorPoint = Vector2.new(0,
	    1),
	    Position = UDim2.new((n - 1) / 28,
	    2,
	    1,
	    -6),
	    Size = UDim2.new(1 / 28,
	    -3,
	    0,
	    3)},
	    __AuraFix_vc)
	__AuraFixUtil.round(b,
	    2)
	__AuraFixUtil.grad(b,
	    function() return ColorSequence.new(__AuraFixUtil.light(accent):Lerp(accent,
	    .4),
	    accent) end,
	    {Rotation = 90})
	local cap = __AuraFixUtil.new("Frame",
	    {AnchorPoint = Vector2.new(0,
	    1),
	    Position = UDim2.new((n - 1) / 28,
	    2,
	    1,
	    -11),
	    Size = UDim2.new(1 / 28,
	    -3,
	    0,
	    2)},
	    __AuraFix_vc)
	__AuraFixUtil.round(cap,
	    1); __AuraFixUtil.acc(cap,
	    "BackgroundColor3")
	__AuraFix_bars[n] = {f = b,
	    c = cap,
	    h = 0,
	    p = 0}
end
prog = __AuraFixUtil.slider(__AuraFix_pg,
    "Трек",
    0,
    1,
    0,
    function(v)
	local l = sound.TimeLength
	return __AuraFixUtil.fmtT(v * l) .. " / " .. __AuraFixUtil.fmtT(l)
end,
    function(v)
	if sound.TimeLength > 0 then sound.TimePosition = v * sound.TimeLength end
end,
    nil,
    nil,
    true)
__AuraFix_r = __AuraFixUtil.row(__AuraFix_pg,
    32)
__AuraFix_q = UDim2.new(.25,
    -5,
    1,
    0)
__AuraFixUtil.button(__AuraFix_r,
    "-10с",
    function() sound.TimePosition = math.max(0,
    sound.TimePosition - 10) end,
    false,
    __AuraFix_q)
pauseB = __AuraFixUtil.button(__AuraFix_r,
    "Пауза",
    function()
	if sound.IsPlaying then sound:Pause()
	elseif sound.IsPaused then sound:Resume()
	elseif sound.SoundId ~= "" then endedF = false; sound:Play() end
end,
    true,
    __AuraFix_q)
__AuraFixUtil.button(__AuraFix_r,
    "Стоп",
    function()
	playTok += 1
	sound:Stop()
	if not trackOK and touched then __AuraFixUtil.setStatus(T("Остановлено")) end
end,
    false,
    __AuraFix_q)
__AuraFixUtil.button(__AuraFix_r,
    "+10с",
    function() sound.TimePosition = math.min(sound.TimeLength,
    sound.TimePosition + 10) end,
    false,
    __AuraFix_q)
__AuraFixUtil.toggle(__AuraFix_pg,
    "Повтор трека",
    false,
    function(v) sound.Looped = v end,
    "loop")

__AuraFixUtil.section(__AuraFix_pg,
    "СКОРОСТЬ И ТОНАЛЬНОСТЬ")
spd = __AuraFixUtil.slider(__AuraFix_pg,
    "Скорость",
    .25,
    3,
    1,
    function(v) return string.format("%.2fx",
    v) end,
    function(v) S.speed = v; __AuraFixUtil.applyAudio() end,
    .05,
    "speed")
tapeT = __AuraFixUtil.toggle(__AuraFix_pg,
    "Менять тон со скоростью",
    true,
    function(v) S.tape = v; __AuraFixUtil.applyAudio() end,
    "tape")
semi = __AuraFixUtil.slider(__AuraFix_pg,
    "Тональность",
    -12,
    12,
    0,
    function(v) return string.format("%+.0f %s",
    v,
    T("пт")) end,
    function(v) S.semi = v; __AuraFixUtil.applyAudio() end,
    1,
    "semi")
__AuraFixUtil.section(__AuraFix_pg,
    "ГРОМКОСТЬ")
vol = __AuraFixUtil.slider(__AuraFix_pg,
    "Усиление",
    -40,
    20,
    0,
    __AuraFixUtil.dbfmt,
    function(v) S.db = v; __AuraFixUtil.applyAudio() end,
    1,
    "db")
__AuraFix_volumeQuick = __AuraFixUtil.row(__AuraFix_pg,
    30)
__AuraFixUtil.button(__AuraFix_volumeQuick,
    "Тихо",
    function() vol.Set(-12); __AuraFixUtil.toast("Тихо") end,
    false,
    __AuraFix_q)
__AuraFixUtil.button(__AuraFix_volumeQuick,
    "Обычный",
    function() vol.Set(0); __AuraFixUtil.toast("Обычный") end,
    false,
    __AuraFix_q)
__AuraFixUtil.button(__AuraFix_volumeQuick,
    "Громко",
    function() vol.Set(8); __AuraFixUtil.toast("Громко") end,
    false,
    __AuraFix_q)
__AuraFixUtil.button(__AuraFix_volumeQuick,
    "Максимум",
    function() vol.Set(16); __AuraFixUtil.toast("Максимум",
    C.warn) end,
    false,
    __AuraFix_q)
__AuraFixUtil.section(__AuraFix_pg,
    "БЫСТРЫЕ НАСТРОЙКИ")
__AuraFix_musicOptions = __AuraFixUtil.row(__AuraFix_pg,
    30)
__AuraFixUtil.button(__AuraFix_musicOptions,
    "Пуск / пауза",
    function()
	if sound.IsPlaying then sound:Pause() elseif sound.IsPaused then sound:Resume() elseif sound.SoundId ~= "" then sound:Play() end
end,
    true,
    UDim2.new(.5,
    -3,
    1,
    0))
__AuraFixUtil.button(__AuraFix_musicOptions,
    "Очистить очередь",
    function()
	table.clear(queueItems)
	__AuraFix_renderQueue()
	__AuraFixUtil.toast("Список очищен")
end,
    false,
    UDim2.new(.5,
    -3,
    1,
    0))
__AuraFixUtil.section(__AuraFix_pg,
    "ВИЗУАЛИЗАТОР")
__AuraFixUtil.segment(__AuraFix_pg,
    "Стиль",
    {"Мягкий",
    "Пики",
    "Спектр"},
    function(i) visualizerStyle = i end,
    1,
    "visualizerStyle")
__AuraFixUtil.toggle(__AuraFix_pg,
    "Пульсация акцента",
    true,
    function(v) musicAccentPulse = v end,
    "musicAccentPulse")
__AuraFixUtil.toggle(__AuraFix_pg,
    "Авто-очередь",
    true,
    function(v) queueAutoPlay = v end,
    "queueAutoPlay")
__AuraFixUtil.button(__AuraFix_pg,
    "Сбросить всё",
    __AuraFixUtil.resetAll)

__AuraFix_pe = __AuraFixUtil.page("Эффекты")
function __AuraFix_preset(name,
    fn)
	return function() __AuraFixUtil.resetAll(); fn(); __AuraFixUtil.toast(T("Пресет: ") .. name) end
end
__AuraFixUtil.section(__AuraFix_pe,
    "ПРЕСЕТЫ")
__AuraFix_pr = __AuraFixUtil.row(__AuraFix_pe,
    30)
__AuraFixUtil.button(__AuraFix_pr,
    "Ночной",
    __AuraFix_preset("Ночной",
    function() spd.Set(1.08); tapeT.Set(true); bassS.Set(4); midS.Set(-2); trebS.Set(2); reverbT.Set(true); reverb.DecayTime = 2.2; reverb.WetLevel = -8 end),
    false,
    __AuraFix_q)
__AuraFixUtil.button(__AuraFix_pr,
    "Замедленный",
    __AuraFix_preset("Замедленный",
    function() spd.Set(.78); tapeT.Set(true); bassS.Set(3); midS.Set(0); trebS.Set(-2); reverbT.Set(true); reverb.DecayTime = 3.5; reverb.WetLevel = -5 end),
    false,
    __AuraFix_q)
__AuraFixUtil.button(__AuraFix_pr,
    "Бас",
    __AuraFix_preset("Бас",
    function() bassS.Set(10); midS.Set(-4); trebS.Set(2); reverbT.Set(false); echoT.Set(false) end),
    false,
    __AuraFix_q)
__AuraFix_pr2 = __AuraFixUtil.row(__AuraFix_pe,
    30)
__AuraFixUtil.button(__AuraFix_pr2,
    "Клуб",
    __AuraFix_preset("Клуб",
    function() spd.Set(1.02); tapeT.Set(false); bassS.Set(8); midS.Set(1); trebS.Set(5); reverbT.Set(true); reverb.WetLevel = -10; echoT.Set(true); echo.Delay = .22; echo.Feedback = .28; echo.WetLevel = -9 end),
    false,
    __AuraFix_q)
__AuraFixUtil.button(__AuraFix_pr2,
    "Радио",
    __AuraFix_preset("Радио",
    function() spd.Set(1); tapeT.Set(false); bassS.Set(-8); midS.Set(5); trebS.Set(-5); reverbT.Set(false); echoT.Set(false) end),
    false,
    __AuraFix_q)
__AuraFix_pr3 = __AuraFixUtil.row(__AuraFix_pe,
    30)
__AuraFixUtil.button(__AuraFix_pr3,
    "Тёплый",
    __AuraFix_preset("Тёплый",
    function() spd.Set(1); tapeT.Set(false); bassS.Set(4); midS.Set(2); trebS.Set(-3); reverbT.Set(true); reverb.DecayTime = 2.6; reverb.WetLevel = -9; echoT.Set(false) end),
    false,
    __AuraFix_q)
__AuraFixUtil.button(__AuraFix_pr3,
    "Яркий звук",
    __AuraFix_preset("Яркий звук",
    function() spd.Set(1); tapeT.Set(false); bassS.Set(1); midS.Set(1); trebS.Set(7); reverbT.Set(false); echoT.Set(false) end),
    false,
    __AuraFix_q)
__AuraFixUtil.button(__AuraFix_pr3,
    "Сброс",
    function() __AuraFixUtil.resetAll(); __AuraFixUtil.toast("Всё сброшено") end,
    false,
    __AuraFix_q)
__AuraFixUtil.section(__AuraFix_pe,
    "ЭКВАЛАЙЗЕР")
bassS = __AuraFixUtil.slider(__AuraFix_pe,
    "Низкие",
    -20,
    10,
    0,
    __AuraFixUtil.dbfmt,
    function(v) eq.LowGain = v end,
    1,
    "bass")
midS = __AuraFixUtil.slider(__AuraFix_pe,
    "Средние",
    -20,
    10,
    0,
    __AuraFixUtil.dbfmt,
    function(v) eq.MidGain = v end,
    1,
    "mid")
trebS = __AuraFixUtil.slider(__AuraFix_pe,
    "Высокие",
    -20,
    10,
    0,
    __AuraFixUtil.dbfmt,
    function(v) eq.HighGain = v end,
    1,
    "treb")
__AuraFixUtil.section(__AuraFix_pe,
    "ПРОСТРАНСТВО")
reverbT = __AuraFixUtil.toggle(__AuraFix_pe,
    "Реверберация",
    false,
    function(v) reverb.Enabled = v end,
    "reverb")
echoT = __AuraFixUtil.toggle(__AuraFix_pe,
    "Эхо",
    false,
    function(v) echo.Enabled = v end,
    "echo")
__AuraFixUtil.section(__AuraFix_pe,
    "НАСТРОЙКИ ПРОСТРАНСТВА")
reverbDecayS = __AuraFixUtil.slider(__AuraFix_pe,
    "Длина реверберации",
    1,
    8,
    2.8,
    function(v) return string.format("%.1fs",
    v) end,
    function(v) reverb.DecayTime = v end,
    .1,
    "reverbDecay")
reverbWetS = __AuraFixUtil.slider(__AuraFix_pe,
    "Сила реверберации",
    -20,
    0,
    -4,
    __AuraFixUtil.dbfmt,
    function(v) reverb.WetLevel = v end,
    1,
    "reverbWet")
echoDelayS = __AuraFixUtil.slider(__AuraFix_pe,
    "Эхо-задержка",
    .1,
    1,
    .35,
    function(v) return string.format("%.2fs",
    v) end,
    function(v) echo.Delay = v end,
    .05,
    "echoDelay")
echoFeedbackS = __AuraFixUtil.slider(__AuraFix_pe,
    "Обратная связь эха",
    0,
    .8,
    .45,
    function(v) return string.format("%.2f",
    v) end,
    function(v) echo.Feedback = v end,
    .05,
    "echoFeedback")

-- Environment presets use native Roblox post-processing controls.
-- Reference patterns: https://github.com/Eldergenix/Roblox-Game/blob/main/.agents/skills/roblox-lighting/SKILL.md
-- and https://github.com/sebasbimbi/roblox-studio-agent/blob/main/apps/desktop/agent/skills/roblox-lighting/references/full.md
-- Preset values below are authored for AURA; no remote code is executed.
__AuraFix_envBloom = Instance.new("BloomEffect")
__AuraFix_envBloom.Name = "AuraEnvBloom"
__AuraFix_envBloom.Enabled = false
__AuraFix_envBloom.Intensity = 0
__AuraFix_envBloom.Size = 24
__AuraFix_envBloom.Threshold = 1
__AuraFix_envBloom.Parent = Lighting

__AuraFix_envColor = Instance.new("ColorCorrectionEffect")
__AuraFix_envColor.Name = "AuraEnvColor"
__AuraFix_envColor.Enabled = false
__AuraFix_envColor.Brightness = 0
__AuraFix_envColor.Contrast = 0
__AuraFix_envColor.Saturation = 0
__AuraFix_envColor.TintColor = WHITE
__AuraFix_envColor.Parent = Lighting

__AuraFix_envRays = Instance.new("SunRaysEffect")
__AuraFix_envRays.Name = "AuraEnvRays"
__AuraFix_envRays.Enabled = false
__AuraFix_envRays.Intensity = 0
__AuraFix_envRays.Spread = .75
__AuraFix_envRays.Parent = Lighting

__AuraFix_envDOF = Instance.new("DepthOfFieldEffect")
__AuraFix_envDOF.Name = "AuraEnvDOF"
__AuraFix_envDOF.Enabled = false
__AuraFix_envDOF.FarIntensity = 0
__AuraFix_envDOF.NearIntensity = 0
__AuraFix_envDOF.FocusDistance = 50
__AuraFix_envDOF.InFocusRadius = 50
__AuraFix_envDOF.Parent = Lighting

local envLightingBase = {
    Brightness = Lighting.Brightness,
        ClockTime = Lighting.ClockTime,
        Ambient = Lighting.Ambient,
        OutdoorAmbient = Lighting.OutdoorAmbient,
        ExposureCompensation = Lighting.ExposureCompensation,
        GlobalShadows = Lighting.GlobalShadows,
        FogColor = Lighting.FogColor,
        FogStart = Lighting.FogStart,
        FogEnd = Lighting.FogEnd,
}
local envAtmo = Lighting:FindFirstChildOfClass("Atmosphere")
local envCreatedAtmo = envAtmo == nil
if not envAtmo then
    envAtmo = Instance.new("Atmosphere")
    envAtmo.Name = "AuraEnvAtmosphere"
    envAtmo.Density = 0
    envAtmo.Offset = .25
    envAtmo.Haze = 0
    envAtmo.Glare = 0
    envAtmo.Color = WHITE
    envAtmo.Decay = WHITE
    envAtmo.Parent = Lighting
end
local envAtmoBase = {
    Density = envAtmo.Density,
        Offset = envAtmo.Offset,
        Haze = envAtmo.Haze,
        Glare = envAtmo.Glare,
        Color = envAtmo.Color,
        Decay = envAtmo.Decay,
}
local envTerrain = workspace:FindFirstChildOfClass("Terrain") or workspace.Terrain
local envOriginalSkies = {}
for _, object in ipairs(Lighting:GetChildren()) do
    if object:IsA("Sky") and object.Name ~= "AuraEnvSky" then envOriginalSkies[#envOriginalSkies + 1] = object end
end
local envSky = Instance.new("Sky")
envSky.Name = "AuraEnvSky"
envSky.CelestialBodiesShown = true
envSky.StarCount = 3000
envSky.SunAngularSize = 12
envSky.MoonAngularSize = 11
local envSkyIsActive = false
local envClouds = envTerrain:FindFirstChildOfClass("Clouds")
local envCreatedClouds = envClouds == nil
if not envClouds then
    envClouds = Instance.new("Clouds")
    envClouds.Name = "AuraEnvClouds"
    envClouds.Cover = 0
    envClouds.Density = 0
    envClouds.Color = WHITE
end
local envCloudBase = {Cover = envClouds.Cover,
    Density = envClouds.Density,
    Color = envClouds.Color}
envCleanup = function()
    pcall(function()
        Lighting.Brightness = envLightingBase.Brightness
        Lighting.ClockTime = envLightingBase.ClockTime
        Lighting.Ambient = envLightingBase.Ambient
        Lighting.OutdoorAmbient = envLightingBase.OutdoorAmbient
        Lighting.ExposureCompensation = envLightingBase.ExposureCompensation
        Lighting.FogColor = envLightingBase.FogColor
        Lighting.FogStart = envLightingBase.FogStart
        Lighting.FogEnd = envLightingBase.FogEnd
        Lighting.GlobalShadows = envLightingBase.GlobalShadows
    end)
    if envSky and envSky.Parent then pcall(function() envSky:Destroy() end) end
    for _, sky in ipairs(envOriginalSkies) do
        if sky and sky.Parent ~= Lighting then pcall(function() sky.Parent = Lighting end) end
    end
    if envClouds then
        if envCreatedClouds then
            pcall(function() envClouds:Destroy() end)
        elseif envClouds.Parent then
            pcall(function() for property,
                value in pairs(envCloudBase) do envClouds[property] = value end end)
        end
    end
    if envCreatedAtmo then
        if envAtmo and envAtmo.Parent then pcall(function() envAtmo:Destroy() end) end
    elseif envAtmo and envAtmo.Parent then
        pcall(function() for property,
            value in pairs(envAtmoBase) do envAtmo[property] = value end end)
    end
end

local envPreset = math.clamp(math.floor(tonumber(cfg.envPreset) or 0),
    0,
    6)
local envOn = cfg.envBloom == true
local envStrength = math.clamp(tonumber(cfg.envBloomStrength) or 60,
    0,
    100)
local envBaseBloom, envPhase, envTick, envApplyToken = .32, 0, 0, 0
local envButtons = {}
-- Skybox texture references adapted from a public GitHub example; no remote code is executed.
-- https://gist.github.com/dexexisted-alt/655b8fc9323571ef7d46ef55eb66dc38
local envSkySets = {
    [1] = {Bk = "rbxassetid://271042516",
        Dn = "rbxassetid://271077243",
        Ft = "rbxassetid://271042556",
        Lf = "rbxassetid://271042310",
        Rt = "rbxassetid://271042467",
        Up = "rbxassetid://271077958"},
        [2] = {Bk = "rbxassetid://166509999",
        Dn = "rbxassetid://166509999",
        Ft = "rbxassetid://166509999",
        Lf = "rbxassetid://166509999",
        Rt = "rbxassetid://166509999",
        Up = "rbxassetid://166509999"},
        [3] = {Bk = "rbxassetid://159454299",
        Dn = "rbxassetid://159454299",
        Ft = "rbxassetid://159454299",
        Lf = "rbxassetid://159454299",
        Rt = "rbxassetid://159454299",
        Up = "rbxassetid://159454299"},
}
local envPresets = {
    [0] = {name = "Исходный вид",
        clockTime = envLightingBase.ClockTime,
        lightBrightness = envLightingBase.Brightness,
        ambient = envLightingBase.Ambient,
        outdoorAmbient = envLightingBase.OutdoorAmbient,
        exposure = envLightingBase.ExposureCompensation,
        fogColor = envLightingBase.FogColor,
        fogStart = envLightingBase.FogStart,
        fogEnd = envLightingBase.FogEnd,
        bloom = 0,
        size = 24,
        threshold = 1,
        brightness = 0,
        contrast = 0,
        saturation = 0,
        tint = WHITE,
        rays = 0,
        spread = .75,
        atmo = {Density = envAtmoBase.Density,
        Offset = envAtmoBase.Offset,
        Haze = envAtmoBase.Haze,
        Glare = envAtmoBase.Glare,
        Color = envAtmoBase.Color,
        Decay = envAtmoBase.Decay},
        dofFar = 0,
        dofNear = 0,
        focus = 50,
        radius = 50},
        [1] = {name = "Кинематограф",
        clockTime = 17.4,
        lightBrightness = 2.4,
        ambient = Color3.fromRGB(105,
        91,
        115),
        outdoorAmbient = Color3.fromRGB(151,
        124,
        135),
        exposure = .12,
        fogColor = Color3.fromRGB(198,
        145,
        128),
        fogStart = 0,
        fogEnd = 900,
        sky = 2,
        skyRotation = 0,
        cloudCover = .18,
        cloudDensity = .32,
        cloudColor = Color3.fromRGB(231,
        216,
        255),
        bloom = .48,
        size = 36,
        threshold = .82,
        brightness = .025,
        contrast = .16,
        saturation = .18,
        tint = Color3.fromRGB(255,
        225,
        197),
        rays = .055,
        spread = .82,
        atmo = {Density = .18,
        Offset = .22,
        Haze = .72,
        Glare = .12,
        Color = Color3.fromRGB(255,
        226,
        199),
        Decay = Color3.fromRGB(115,
        104,
        125)},
        dofFar = .025,
        dofNear = 0,
        focus = 65,
        radius = 90},
        [2] = {name = "Неоновые сумерки",
        clockTime = 19.6,
        lightBrightness = 1.8,
        ambient = Color3.fromRGB(76,
        65,
        132),
        outdoorAmbient = Color3.fromRGB(91,
        81,
        155),
        exposure = .05,
        fogColor = Color3.fromRGB(80,
        72,
        155),
        fogStart = 0,
        fogEnd = 700,
        sky = 3,
        skyRotation = 35,
        cloudCover = .28,
        cloudDensity = .48,
        cloudColor = Color3.fromRGB(170,
        157,
        255),
        bloom = .62,
        size = 42,
        threshold = .72,
        brightness = .015,
        contrast = .24,
        saturation = .32,
        tint = Color3.fromRGB(222,
        194,
        255),
        rays = .02,
        spread = .9,
        atmo = {Density = .14,
        Offset = .15,
        Haze = .9,
        Glare = .1,
        Color = Color3.fromRGB(185,
        169,
        255),
        Decay = Color3.fromRGB(65,
        86,
        157)},
        dofFar = .015,
        dofNear = 0,
        focus = 70,
        radius = 100},
        [3] = {name = "Лавандовый сон",
        clockTime = 16.8,
        lightBrightness = 2.3,
        ambient = Color3.fromRGB(130,
        100,
        160),
        outdoorAmbient = Color3.fromRGB(170,
        140,
        195),
        exposure = .1,
        fogColor = Color3.fromRGB(192,
        160,
        220),
        fogStart = 0,
        fogEnd = 1000,
        sky = 3,
        skyRotation = 105,
        cloudCover = .22,
        cloudDensity = .40,
        cloudColor = Color3.fromRGB(205,
        190,
        255),
        bloom = .52,
        size = 38,
        threshold = .78,
        brightness = .035,
        contrast = .13,
        saturation = .28,
        tint = Color3.fromRGB(231,
        214,
        255),
        rays = .025,
        spread = .78,
        atmo = {Density = .12,
        Offset = .27,
        Haze = .55,
        Glare = .08,
        Color = Color3.fromRGB(227,
        207,
        255),
        Decay = Color3.fromRGB(139,
        128,
        184)},
        dofFar = .04,
        dofNear = .01,
        focus = 60,
        radius = 120},
        [4] = {name = "Изумрудный туман",
        clockTime = 7.1,
        lightBrightness = 1.7,
        ambient = Color3.fromRGB(55,
        112,
        95),
        outdoorAmbient = Color3.fromRGB(77,
        150,
        120),
        exposure = -.08,
        fogColor = Color3.fromRGB(78,
        160,
        124),
        fogStart = 0,
        fogEnd = 500,
        sky = 3,
        skyRotation = 185,
        cloudCover = .34,
        cloudDensity = .54,
        cloudColor = Color3.fromRGB(145,
        255,
        210),
        bloom = .43,
        size = 34,
        threshold = .86,
        brightness = -.015,
        contrast = .2,
        saturation = .24,
        tint = Color3.fromRGB(190,
        255,
        225),
        rays = .018,
        spread = .76,
        atmo = {Density = .24,
        Offset = .18,
        Haze = 1.55,
        Glare = .03,
        Color = Color3.fromRGB(167,
        244,
        208),
        Decay = Color3.fromRGB(61,
        112,
        99)},
        dofFar = .015,
        dofNear = 0,
        focus = 55,
        radius = 100},
        [5] = {name = "Кристальный лёд",
        clockTime = 10.5,
        lightBrightness = 2.8,
        ambient = Color3.fromRGB(115,
        160,
        195),
        outdoorAmbient = Color3.fromRGB(160,
        205,
        235),
        exposure = .18,
        fogColor = Color3.fromRGB(170,
        215,
        255),
        fogStart = 0,
        fogEnd = 1200,
        sky = 1,
        skyRotation = 235,
        cloudCover = .16,
        cloudDensity = .30,
        cloudColor = Color3.fromRGB(185,
        231,
        255),
        bloom = .46,
        size = 36,
        threshold = .8,
        brightness = .025,
        contrast = .17,
        saturation = .18,
        tint = Color3.fromRGB(196,
        235,
        255),
        rays = .065,
        spread = .88,
        atmo = {Density = .10,
        Offset = .30,
        Haze = .42,
        Glare = .14,
        Color = Color3.fromRGB(197,
        232,
        255),
        Decay = Color3.fromRGB(111,
        153,
        202)},
        dofFar = .02,
        dofNear = 0,
        focus = 75,
        radius = 110},
        -- Custom AURA preset: animated prismatic tint with restrained glow waves.
    [6] = {name = "Призматическая аврора",
        clockTime = 20.2,
        lightBrightness = 2.1,
        ambient = Color3.fromRGB(65,
        125,
        130),
        outdoorAmbient = Color3.fromRGB(95,
        175,
        155),
        exposure = .08,
        fogColor = Color3.fromRGB(95,
        190,
        175),
        fogStart = 0,
        fogEnd = 850,
        sky = 3,
        skyRotation = 0,
        cloudCover = .26,
        cloudDensity = .47,
        cloudColor = Color3.fromRGB(145,
        255,
        226),
        bloom = .58,
        size = 40,
        threshold = .76,
        brightness = .02,
        contrast = .19,
        saturation = .32,
        tint = Color3.fromRGB(175,
        255,
        228),
        rays = .028,
        spread = .86,
        atmo = {Density = .13,
        Offset = .25,
        Haze = .82,
        Glare = .09,
        Color = Color3.fromRGB(169,
        255,
        229),
        Decay = Color3.fromRGB(93,
        106,
        190)},
        dofFar = .015,
        dofNear = 0,
        focus = 70,
        radius = 100},
}

function __AuraFixUtil.applyEnvironmentPreset(index)
    index = math.clamp(math.floor(tonumber(index) or 0),
        0,
        6)
    envPreset = index
    cfg.envPreset = index
    envApplyToken += 1
    local token = envApplyToken
    local p = envPresets[index] or envPresets[0]
    local active = envOn and index ~= 0 and envStrength > 0
    envBaseBloom = p.bloom

    __AuraFix_envBloom.Enabled = active or __AuraFix_envBloom.Enabled
    __AuraFix_envColor.Enabled = active or __AuraFix_envColor.Enabled
    __AuraFix_envRays.Enabled = active or __AuraFix_envRays.Enabled
    __AuraFix_envDOF.Enabled = active or __AuraFix_envDOF.Enabled

    if active then
        pcall(function()
            Lighting.Brightness = p.lightBrightness or envLightingBase.Brightness
            Lighting.ClockTime = p.clockTime or envLightingBase.ClockTime
            Lighting.Ambient = p.ambient or envLightingBase.Ambient
            Lighting.OutdoorAmbient = p.outdoorAmbient or envLightingBase.OutdoorAmbient
            Lighting.ExposureCompensation = p.exposure or envLightingBase.ExposureCompensation
            Lighting.FogColor = p.fogColor or envLightingBase.FogColor
            Lighting.FogStart = p.fogStart or envLightingBase.FogStart
            Lighting.FogEnd = p.fogEnd or envLightingBase.FogEnd
            Lighting.GlobalShadows = true
        end)
        for _, originalSky in ipairs(envOriginalSkies) do
            if originalSky and originalSky.Parent == Lighting then originalSky.Parent = nil end
        end
        local skySet = envSkySets[p.sky or 1] or envSkySets[1]
        for property, value in pairs(skySet) do envSky[property] = value end
        envSky.SkyboxOrientation = Vector3.new(0,
            p.skyRotation or 0,
            0)
        envSky.Parent = Lighting
        envSkyIsActive = true
        if envClouds.Parent ~= envTerrain then envClouds.Parent = envTerrain end
        envClouds.Cover = math.clamp(p.cloudCover or .2,
            0,
            1)
        envClouds.Density = math.clamp(p.cloudDensity or .35,
            0,
            1)
        envClouds.Color = p.cloudColor or WHITE
    else
        pcall(function()
            Lighting.Brightness = envLightingBase.Brightness
            Lighting.ClockTime = envLightingBase.ClockTime
            Lighting.Ambient = envLightingBase.Ambient
            Lighting.OutdoorAmbient = envLightingBase.OutdoorAmbient
            Lighting.ExposureCompensation = envLightingBase.ExposureCompensation
            Lighting.FogColor = envLightingBase.FogColor
            Lighting.FogStart = envLightingBase.FogStart
            Lighting.FogEnd = envLightingBase.FogEnd
            Lighting.GlobalShadows = envLightingBase.GlobalShadows
        end)
        if envSky.Parent then envSky.Parent = nil end
        envSkyIsActive = false
        for _, originalSky in ipairs(envOriginalSkies) do
            if originalSky and originalSky.Parent ~= Lighting then pcall(function() originalSky.Parent = Lighting end) end
        end
        if envCreatedClouds then
            if envClouds.Parent then envClouds.Parent = nil end
        elseif envClouds.Parent == envTerrain then
            envClouds.Cover, envClouds.Density, envClouds.Color = envCloudBase.Cover, envCloudBase.Density, envCloudBase.Color
        end
    end

    local strength = math.clamp(envStrength / 60,
        0,
        1.65)
    local bloomGoal = active and math.clamp(p.bloom * strength,
        0,
        1) or 0
    local colorGoal = active and p or envPresets[0]
    local atmoGoal = active and p.atmo or envPresets[0].atmo
    tw(__AuraFix_envBloom,
        {Intensity = bloomGoal,
        Size = active and p.size or 24,
        Threshold = active and p.threshold or 1},
        .72,
        EASE.Sine)
    local colorTween = tw(__AuraFix_envColor,
        {Brightness = colorGoal.brightness,
        Contrast = colorGoal.contrast,
        Saturation = colorGoal.saturation,
        TintColor = colorGoal.tint},
        .78,
        EASE.Sine)
    tw(__AuraFix_envRays,
        {Intensity = active and p.rays * strength or 0,
        Spread = active and p.spread or .75},
        .72,
        EASE.Sine)
    tw(__AuraFix_envDOF,
        {FarIntensity = active and p.dofFar or 0,
        NearIntensity = active and p.dofNear or 0,
        FocusDistance = active and p.focus or 50,
        InFocusRadius = active and p.radius or 50},
        .78,
        EASE.Sine)
    tw(envAtmo,
        {Density = atmoGoal.Density,
        Offset = atmoGoal.Offset,
        Haze = atmoGoal.Haze,
        Glare = atmoGoal.Glare,
        Color = atmoGoal.Color,
        Decay = atmoGoal.Decay},
        .85,
        EASE.Sine)
    colorTween.Completed:Connect(function()
        if envApplyToken ~= token then return end
        if not active then
            __AuraFix_envBloom.Enabled = false
            __AuraFix_envColor.Enabled = false
            __AuraFix_envRays.Enabled = false
            __AuraFix_envDOF.Enabled = false
        end
    end)
    for i, b in ipairs(envButtons) do
        if b and b.Parent then tw(b,
            {BackgroundColor3 = i == index and accent or C.card2},
            .32,
            EASE.Quint) end
    end
end

function __AuraFixUtil.selectEnvironmentPreset(index)
    envOn = true
    cfg.envBloom = true
    if ctl.envBloom then ctl.envBloom.Set(true,
        true) end
    __AuraFixUtil.applyEnvironmentPreset(index)
    __AuraFixUtil.toast(T("Активен эффект: ") .. T((envPresets[index] or envPresets[0]).name),
        C.good)
end


-- Ambient effects are authored with native Roblox parts, Trails and Tweens.
-- This keeps them self-contained: no remote code or external model requires.
-- Atmospheric particle effects (meteors, aurora dust, snow, etc.) have been removed.

__AuraFix_pv = __AuraFixUtil.page("Визуал")
__AuraFixUtil.section(__AuraFix_pv,
    "ОТОБРАЖЕНИЕ")
__AuraFixUtil.toggle(__AuraFix_pv,
    "Подсветка игроков",
    true,
    function(v) V.hl = v; __AuraFixUtil.refresh() end,
    "hl")
__AuraFixUtil.toggle(__AuraFix_pv,
    "Рамка игрока",
    true,
    function(v) V.box = v; __AuraFixUtil.refresh() end,
    "box")
__AuraFixUtil.toggle(__AuraFix_pv,
    "Полоса здоровья",
    true,
    function(v) V.health = v; __AuraFixUtil.refresh() end,
    "health")
__AuraFixUtil.toggle(__AuraFix_pv,
    "Трассеры",
    false,
    function(v) V.tracers = v; __AuraFixUtil.refresh() end,
    "tracers")
__AuraFixUtil.toggle(__AuraFix_pv,
    "Скелет",
    false,
    function(v) V.skel = v; __AuraFixUtil.refresh() end,
    "skel")
__AuraFixUtil.toggle(__AuraFix_pv,
    "Имена",
    true,
    function(v) V.names = v; __AuraFixUtil.refresh() end,
    "names")
__AuraFixUtil.toggle(__AuraFix_pv,
    "Дистанция",
    false,
    function(v) V.dist = v; __AuraFixUtil.refresh() end,
    "dist")
__AuraFixUtil.toggle(__AuraFix_pv,
    "Здоровье в имени",
    false,
    function(v) V.healthText = v; __AuraFixUtil.refresh() end,
    "healthText")
__AuraFixUtil.toggle(__AuraFix_pv,
    "Проверка команды",
    false,
    function(v) V.teamCheck = v; __AuraFixUtil.refresh() end,
    "teamCheck")
__AuraFixUtil.slider(__AuraFix_pv,
    "Дальность",
    50,
    1000,
    250,
    function(v) return string.format("%d %s",
    v,
    T("ст.")) end,
    function(v) V.range = v end,
    10,
    "range")
__AuraFixUtil.segment(__AuraFix_pv,
    "Стиль",
    {"Контур",
    "Заливка",
    "Градиент"},
    function(i) V.style = i end,
    1,
    "style")
__AuraFixUtil.section(__AuraFix_pv,
    "ЦВЕТ И ПЛАВНОСТЬ")
__AuraFixUtil.slider(__AuraFix_pv,
    "Яркость ESP",
    25,
    100,
    100,
    function(v) return string.format("%d%%",
    v) end,
    function(v) V.brightness = v / 100 end,
    5,
    "espBrightness")
__AuraFixUtil.slider(__AuraFix_pv,
    "Размер подписей",
    10,
    18,
    13,
    function(v) return string.format("%d px",
    v) end,
    function(v) V.labelSize = v end,
    1,
    "labelSize")
__AuraFixUtil.slider(__AuraFix_pv,
    "Толщина рамки",
    1,
    4,
    1.5,
    function(v) return string.format("%.1f px",
    v) end,
    function(v) V.lineWidth = v end,
    .5,
    "lineWidth")
__AuraFixUtil.slider(__AuraFix_pv,
    "Толщина скелета",
    1,
    4,
    1.5,
    function(v) return string.format("%.1f px",
    v) end,
    function(v) V.skelWidth = v end,
    .5,
    "skelWidth")
do
    __AuraFixUtil.toggle(__AuraFix_pv, "Уголки рамки", true, function(v) V.corners = v end, "corners")
    __AuraFixUtil.toggle(__AuraFix_pv, "Стрелки за экраном", true, function(v) V.arrows = v; __AuraFixUtil.refresh() end, "arrows")
    __AuraFixUtil.toggle(__AuraFix_pv, "Точка головы", true, function(v) V.headDot = v; __AuraFixUtil.refresh() end, "headDot")
    __AuraFixUtil.toggle(__AuraFix_pv, "Проверка видимости", true, function(v) V.visCheck = v end, "visCheck")
end
__AuraFix_espActions = __AuraFixUtil.row(__AuraFix_pv,
    32)
__AuraFixUtil.button(__AuraFix_espActions,
    "Всё включить",
    function()
	for _, key in ipairs({"hl",
	    "box",
	    "health",
	    "tracers",
	    "skel",
	    "names",
	    "dist",
	    "healthText"}) do
		if ctl[key] then ctl[key].Set(true) end
	end
	__AuraFixUtil.refresh()
	__AuraFixUtil.toast("Включено",
	    C.good)
end,
    true,
    UDim2.new(.5,
    -3,
    1,
    0))
__AuraFixUtil.button(__AuraFix_espActions,
    "Всё скрыть",
    function()
	for _, key in ipairs({"hl",
	    "box",
	    "health",
	    "tracers",
	    "skel",
	    "names",
	    "dist",
	    "healthText"}) do
		if ctl[key] then ctl[key].Set(false) end
	end
	__AuraFixUtil.refresh()
	__AuraFixUtil.toast("Выключено",
	    C.warn)
end,
    false,
    UDim2.new(.5,
    -3,
    1,
    0))

__AuraFix_pm = __AuraFixUtil.page("Разное")
__AuraFixUtil.section(__AuraFix_pm,
    "ОБЩЕЕ")
__AuraFixUtil.toggle(__AuraFix_pm,
    "Анти-АФК",
    true,
    function(v) afkOn = v end,
    "afk")
__AuraFixUtil.toggle(__AuraFix_pm,
    "Показывать FPS",
    false,
    function(v) V.fps = v; __AuraFixUtil.showFps(v) end,
    "fps")
__AuraFixUtil.toggle(__AuraFix_pm,
    "Авто-перезаход",
    false,
    function(v) rejoinOn = v end,
    "rejoin")
__AuraFixUtil.slider(__AuraFix_pm,
    "Поле зрения",
    50,
    120,
    70,
    function(v) return string.format("%.0f°",
    v) end,
    function(v) fovT = v; fovOn = true end,
    1,
    "fov")
__AuraFixUtil.segment(__AuraFix_pm,
    "Язык",
    {"Русский",
    "English",
    "Español"},
    setLang,
    1,
    "lang")
__AuraFix_cr = __AuraFixUtil.row(__AuraFix_pm,
    32)
__AuraFix_half = UDim2.new(.5,
    -3,
    1,
    0)
__AuraFixUtil.button(__AuraFix_cr,
    "Сохранить конфиг",
    function()
	local ok = __AuraFixUtil.saveCfg()
	__AuraFixUtil.toast(ok and "Конфиг сохранён" or "Сохранение недоступно",
	    ok and C.good or C.bad)
end,
    true,
    __AuraFix_half)
__AuraFixUtil.button(__AuraFix_cr,
    "Загрузить конфиг",
    function()
	if __AuraFixUtil.loadCfg() then
		for k, o in pairs(ctl) do if cfg[k] ~= nil then o.Set(cfg[k]) end end
		rainbow = cfg.rainbow == true
		if rainbow then __AuraFixUtil.mark(7)
		elseif type(cfg.accent) == "table" and cfg.accent[3] then __AuraFixUtil.setAccent(Color3.new(cfg.accent[1],
		    cfg.accent[2],
		    cfg.accent[3]),
		    0) end
		__AuraFixUtil.toast("Конфиг загружен",
		    C.good)
	else
		__AuraFixUtil.toast("Конфиг не найден",
		    C.bad)
	end
end,
    false,
    __AuraFix_half)

__AuraFix_ps = __AuraFixUtil.page("Настройки")
__AuraFixUtil.section(__AuraFix_ps,
    "ЦВЕТ АКЦЕНТА")
__AuraFix_swc = __AuraFixUtil.card(__AuraFix_ps,
    46)
__AuraFixUtil.new("UIListLayout",
    {FillDirection = Enum.FillDirection.Horizontal,
    HorizontalAlignment = Enum.HorizontalAlignment.Center,
    VerticalAlignment = Enum.VerticalAlignment.Center,
    Padding = UDim.new(0,
    10)},
    __AuraFix_swc)
for k, col in ipairs(cols) do
	local b = __AuraFixUtil.new("TextButton",
	    {Text = "",
	    AutoButtonColor = false,
	    BackgroundColor3 = col,
	    Size = UDim2.fromOffset(26,
	    26)},
	    __AuraFix_swc)
	__AuraFixUtil.round(b,
	    13); __AuraFixUtil.press(b,
	    true)
	swb[k] = {S = __AuraFixUtil.stroke(b,
	    2,
	    WHITE,
	    1)}
	cn(b.Activated,
	    function() rainbow = false; cfg.rainbow = false; __AuraFixUtil.setAccent(col,
	    k); __AuraFixUtil.toast("Акцент изменён") end)
end
__AuraFix_rb = __AuraFixUtil.new("TextButton",
    {Text = "",
    AutoButtonColor = false,
    BackgroundColor3 = WHITE,
    Size = UDim2.fromOffset(26,
    26)},
    __AuraFix_swc)
__AuraFixUtil.round(__AuraFix_rb,
    13); __AuraFixUtil.press(__AuraFix_rb,
    true)
__AuraFixUtil.new("UIGradient",
    {Rotation = 45,
    Color = ColorSequence.new({ColorSequenceKeypoint.new(0,
    Color3.fromRGB(255,
    80,
    80)),
    ColorSequenceKeypoint.new(.33,
    Color3.fromRGB(80,
    255,
    120)),
    ColorSequenceKeypoint.new(.66,
    Color3.fromRGB(80,
    140,
    255)),
    ColorSequenceKeypoint.new(1,
    Color3.fromRGB(255,
    80,
    200))})},
    __AuraFix_rb)
swb[7] = {S = __AuraFixUtil.stroke(__AuraFix_rb,
    2,
    WHITE,
    1)}
cn(__AuraFix_rb.Activated,
    function()
	rainbow = not rainbow
	cfg.rainbow = rainbow
	if rainbow then __AuraFixUtil.mark(7) else __AuraFixUtil.mark(0) end
	__AuraFixUtil.toast(rainbow and "Радужный режим" or "Радуга выключена")
end)
do
	local sel = 0
	for k, c in ipairs(cols) do
		if (c.R - accent.R) ^ 2 + (c.G - accent.G) ^ 2 + (c.B - accent.B) ^ 2 < 1e-4 then sel = k end
	end
	__AuraFixUtil.mark(rainbow and 7 or sel)
end
__AuraFixUtil.slider(__AuraFix_ps,
    "Оттенок",
    0,
    360,
    (accent:ToHSV()) * 360,
    function(v) return string.format("%.0f°",
    v) end,
    function(v)
	rainbow = false; cfg.rainbow = false
	__AuraFixUtil.setAccent(Color3.fromHSV(v / 360,
	    .65,
	    1),
	    0,
	    true)
end,
    1)
__AuraFixUtil.section(__AuraFix_ps,
    "ОКНО")
__AuraFixUtil.slider(__AuraFix_ps,
    "Прозрачность",
    0,
    50,
    0,
    function(v) return string.format("%.0f%%",
    v) end,
    function(v)
	baseGT = v / 100
	if opened then tw(main,
	    {GroupTransparency = baseGT},
	    .2) end
end,
    1,
    "gt")
__AuraFixUtil.slider(__AuraFix_ps,
    "Размер меню",
    60,
    130,
    baseScale * 100,
    function(v) return string.format("%.0f%%",
    v) end,
    function(v)
	local camera = workspace.CurrentCamera
	local size = camera and camera.ViewportSize or Vector2.new(800,
	    400)
	-- Let the user both shrink and enlarge the menu. Larger values may
	-- extend beyond the viewport on very small screens, but remain user-controlled.
	baseScale = math.clamp(v / 100, .52, 1.30)
	tw(mscale,
	    {Scale = baseScale},
	    .32,
	    EASE.Quint)
	startPos = UDim2.new(.5,
	    0,
	    0,
	    math.max(6,
	    (size.Y - WIN_H * baseScale) / 2))
end,
    5,
    "size")
__AuraFixUtil.toggle(__AuraFix_ps,
    "Размытие фона",
    true,
    function(v)
	blurOn = v
	if opened then tw(blur,
	    {Size = v and 14 or 0},
	    .3) end
end,
    "blur")
__AuraFix_settingsQuick = __AuraFixUtil.row(__AuraFix_ps,
    32)
__AuraFixUtil.button(__AuraFix_settingsQuick,
    "Сбросить позицию",
    function() tw(holder,
    {Position = startPos},
    .6,
    EASE.Back) end,
    false,
    UDim2.new(.5,
    -3,
    1,
    0))
__AuraFixUtil.button(__AuraFix_settingsQuick,
    "Сбросить конфиг",
    function()
	cfg = {}
	rainbow = false
	for _, control in pairs(ctl) do
		if control.Default ~= nil and control.Set then pcall(function() control.Set(control.Default) end) end
	end
	cfg.rainbow = false
	-- Reset the visual preset as well as standard toggles so effects do not linger.
	envPreset,
	    envOn,
	    envStrength = 0,
	    false,
	    60
	cfg.envPreset,
	    cfg.envBloom,
	    cfg.envBloomStrength = 0,
	    false,
	    60
	if ctl.envBloom then ctl.envBloom.Set(false,
	    true) end
	if ctl.envBloomStrength then ctl.envBloomStrength.Set(60,
	    true) end
	__AuraFixUtil.applyEnvironmentPreset(0)
	__AuraFixUtil.setAccent(Color3.fromRGB(130,
	    100,
	    255),
	    1)
	pcall(__AuraFixUtil.saveCfg)
	__AuraFixUtil.toast("Всё сброшено",
	    C.warn)
end,
    false,
    UDim2.new(.5,
    -3,
    1,
    0))
__AuraFixUtil.section(__AuraFix_ps,
    "ИНФОРМАЦИЯ О ПЛЕЕРЕ")
__AuraFix_aboutCard = __AuraFixUtil.card(__AuraFix_ps,
    56)
__AuraFix_aboutOrb = __AuraFixUtil.new("Frame",
    {Position = UDim2.fromOffset(10,
    10),
    Size = UDim2.fromOffset(36,
    36),
    BackgroundColor3 = accent},
    __AuraFix_aboutCard)
__AuraFixUtil.round(__AuraFix_aboutOrb,
    18)
__AuraFixUtil.new("UIGradient",
    {Rotation = 45,
    Color = ColorSequence.new(__AuraFixUtil.light(accent),
    __AuraFixUtil.dark(accent))},
    __AuraFix_aboutOrb)
__AuraFixUtil.lbl(__AuraFix_aboutOrb,
    "A",
    18,
    WHITE,
    {TextXAlignment = Enum.TextXAlignment.Center,
    Font = Enum.Font.GothamBlack})
__AuraFixUtil.lbl(__AuraFix_aboutCard,
    lp.DisplayName,
    12,
    C.text,
    {Position = UDim2.fromOffset(56,
    8),
    Size = UDim2.new(1,
    -66,
    0,
    18),
    Font = Enum.Font.GothamBold})
__AuraFixUtil.lbl(__AuraFix_aboutCard,
    "@" .. lp.Name .. " · " .. tostring(lp.UserId),
    10,
    C.sub,
    {Position = UDim2.fromOffset(56,
    27),
    Size = UDim2.new(1,
    -66,
    0,
    16)})
__AuraFixUtil.button(__AuraFix_ps,
    "Выгрузить меню",
    function() __AuraFixUtil.setOpen(false); task.delay(.4,
    __AuraFixUtil.unload) end)

do
    local Util = __AuraFixUtil
    local new = Util.new
    local nk = NumberSequenceKeypoint.new

    Util.cleanups = Util.cleanups or {}
    function Util.extraCleanup()
        for _, f in ipairs(Util.cleanups) do pcall(f) end
    end

    local function parts()
        local ch = lp.Character
        return ch, ch and ch:FindFirstChild("HumanoidRootPart"), ch and ch:FindFirstChildOfClass("Humanoid")
    end

    local FLY = {on = false, speed = 60, smooth = 8, vel = Vector3.zero, kUp = false, kDown = false, tUp = false, tDown = false}
    Util.fly = FLY

    local function flyStop()
        for _, k in ipairs({"att", "lv", "ao"}) do
            if FLY[k] then pcall(function() FLY[k]:Destroy() end) FLY[k] = nil end
        end
        local _, _, hum = parts()
        if hum then
            hum.PlatformStand = false
            hum:ChangeState(Enum.HumanoidStateType.Freefall)
        end
        FLY.vel = Vector3.zero
    end

    local function flyStart()
        flyStop()
        local _, hrp, hum = parts()
        if not (hrp and hum) then return false end
        FLY.att = new("Attachment", {Name = "AuraFlyAtt"}, hrp)
        FLY.lv = new("LinearVelocity", {Name = "AuraFlyLV", Attachment0 = FLY.att, MaxForce = 1e9, VelocityConstraintMode = Enum.VelocityConstraintMode.Vector, RelativeTo = Enum.ActuatorRelativeTo.World, VectorVelocity = Vector3.zero}, hrp)
        FLY.ao = new("AlignOrientation", {Name = "AuraFlyAO", Attachment0 = FLY.att, Mode = Enum.OrientationAlignmentMode.OneAttachment, MaxTorque = 1e8, Responsiveness = 22, CFrame = hrp.CFrame}, hrp)
        hum.PlatformStand = true
        FLY.vel = hrp.AssemblyLinearVelocity
        return true
    end

    local flyBtns = {}
    for idx, info in ipairs({{"▲", "tUp", -122}, {"▼", "tDown", -70}}) do
        local b = new("TextButton", {Text = info[1], Font = Enum.Font.GothamBlack, TextSize = 20, TextColor3 = WHITE, AutoButtonColor = false, BackgroundColor3 = C.bar, BackgroundTransparency = .1, AnchorPoint = Vector2.new(1, .5), Position = UDim2.new(1, -18, .5, info[3]), Size = UDim2.fromOffset(48, 48), Visible = false}, gui)
        Util.round(b, 24)
        local st = Util.stroke(b, 1.6, accent, .25)
        Util.acc(st, "Color")
        Util.press(b)
        cn(b.MouseButton1Down, function() FLY[info[2]] = true end)
        cn(b.MouseButton1Up, function() FLY[info[2]] = false end)
        cn(b.MouseLeave, function() FLY[info[2]] = false end)
        flyBtns[idx] = b
    end

    function Util.flySet(v)
        v = v and true or false
        if v == FLY.on then return end
        if v then
            if not flyStart() then
                Util.toast("Персонаж не найден", C.bad)
                if Util.flyToggle then task.defer(Util.flyToggle.Set, false, true) end
                return
            end
            FLY.on = true
        else
            FLY.on = false
            flyStop()
        end
        for _, b in ipairs(flyBtns) do
            if v and UIS.TouchEnabled then
                b.Visible = true
                b.Size = UDim2.fromOffset(30, 30)
                tw(b, {Size = UDim2.fromOffset(48, 48)}, .35, EASE.Back)
            else
                b.Visible = false
            end
        end
    end

    cn(RS.Heartbeat, function(dt)
        if not FLY.on then return end
        local _, hrp, hum = parts()
        local cam = workspace.CurrentCamera
        if not (hrp and hum and cam and FLY.lv and FLY.lv.Parent) then return end
        local cf = cam.CFrame
        local look, right = cf.LookVector, cf.RightVector
        local flatLook = Vector3.new(look.X, 0, look.Z)
        local flatRight = Vector3.new(right.X, 0, right.Z)
        flatLook = flatLook.Magnitude > .001 and flatLook.Unit or Vector3.new(0, 0, -1)
        flatRight = flatRight.Magnitude > .001 and flatRight.Unit or Vector3.new(1, 0, 0)
        local md = hum.MoveDirection
        local f, s = md:Dot(flatLook), md:Dot(flatRight)
        local vert = ((FLY.kUp or FLY.tUp) and 1 or 0) - ((FLY.kDown or FLY.tDown) and 1 or 0)
        local target = (look * f + right * s) * FLY.speed + Vector3.new(0, vert * FLY.speed * (FLY.vmul or .8), 0)
        FLY.vel = FLY.vel:Lerp(target, 1 - math.exp(-dt * FLY.smooth))
        FLY.lv.VectorVelocity = FLY.vel
        local hv = Vector3.new(FLY.vel.X, 0, FLY.vel.Z)
        local ratio = math.clamp(hv.Magnitude / math.max(FLY.speed, 1), 0, 1)
        local tilt = FLY.tiltOn == false and 0 or math.rad(-ratio * 22 * (f >= 0 and 1 or -1))
        local roll = FLY.tiltOn == false and 0 or math.rad(-s * ratio * 14)
        FLY.ao.CFrame = CFrame.lookAt(Vector3.zero, flatLook) * CFrame.Angles(tilt, 0, roll)
    end)

    cn(lp.CharacterAdded, function(ch)
        if not FLY.on then return end
        task.spawn(function()
            ch:WaitForChild("HumanoidRootPart", 6)
            ch:WaitForChild("Humanoid", 6)
            task.wait(.4)
            if FLY.on then flyStart() end
        end)
    end)

    local NC = {on = false, rec = setmetatable({}, {__mode = "k"})}
    Util.noclip = NC
    function Util.noclipSet(v)
        NC.on = v and true or false
        if not NC.on then
            for p in pairs(NC.rec) do
                if p.Parent then p.CanCollide = true end
            end
            table.clear(NC.rec)
        end
    end
    cn(RS.Stepped, function()
        if not NC.on then return end
        local ch = lp.Character
        if not ch then return end
        for _, p in ipairs(ch:GetDescendants()) do
            if p:IsA("BasePart") and p.CanCollide then
                NC.rec[p] = true
                p.CanCollide = false
            end
        end
    end)

    local KC, UT = Enum.KeyCode, Enum.UserInputType
    local DEFAULT_BINDS = {
        fly = {"K", KC.F}, noclip = {"K", KC.N}, aimbot = {"K", KC.B}, assist = {"K", KC.V}, aura = {"K", KC.H},
        menu = {"K", KC.RightShift}, up = {"K", KC.Space}, down = {"K", KC.LeftControl}, hold = {"M", UT.MouseButton2},
    }
    Util.defaultBinds = DEFAULT_BINDS
    Util.binds = {}

    local function decodeBind(str)
        local kind, name = tostring(str):match("^(%a):(.+)$")
        if not kind then return nil end
        local ok, v = pcall(function() return kind == "K" and KC[name] or UT[name] end)
        if ok and v then return {kind, v} end
        return nil
    end
    function Util.encodeBind(b) return b and (b[1] .. ":" .. b[2].Name) or "" end

    local saved = type(cfg.binds) == "table" and cfg.binds or {}
    for id, def in pairs(DEFAULT_BINDS) do
        if saved[id] == "" then Util.binds[id] = nil
        else Util.binds[id] = decodeBind(saved[id]) or {def[1], def[2]} end
    end
    for _, id in ipairs({"rtx", "esp", "nextpart"}) do Util.binds[id] = decodeBind(saved[id]) end

    function Util.isBind(id, i)
        local b = Util.binds[id]
        if not b then return false end
        if b[1] == "K" then return i.KeyCode == b[2] end
        return i.UserInputType == b[2]
    end
    function Util.bindDown(id)
        local b = Util.binds[id]
        if not b then return false end
        if b[1] == "K" then return UIS:IsKeyDown(b[2]) end
        return UIS:IsMouseButtonPressed(b[2])
    end
    function Util.setBind(id, b)
        cfg.binds = type(cfg.binds) == "table" and cfg.binds or {}
        if b then
            for oid, ob in pairs(Util.binds) do
                if oid ~= id and ob[1] == b[1] and ob[2] == b[2] then
                    Util.binds[oid] = nil
                    cfg.binds[oid] = ""
                end
            end
        end
        Util.binds[id] = b
        cfg.binds[id] = Util.encodeBind(b)
        pcall(Util.saveCfg)
    end

    local ESP_KEYS = {"hl", "box", "health", "tracers", "skel", "names", "dist", "healthText"}
    Util.actions = {
        fly = function() if Util.flyToggle then Util.flyToggle.Set(not FLY.on) end end,
        noclip = function() if Util.noclipToggle then Util.noclipToggle.Set(not NC.on) end end,
        aimbot = function() if Util.aimToggle then Util.aimToggle.Set(not Util.aim.on) end end,
        assist = function() if Util.assistToggle then Util.assistToggle.Set(not Util.aim.assist) end end,
        aura = function() if Util.auraToggle then Util.auraToggle.Set(not Util.auraMe.on) end end,
        rtx = function() if Util.rtxSeg then Util.rtxSeg.Set((Util.rtx.mode + 1) % 4 + 1) end end,
        nextpart = function() if ctl.aimPart then ctl.aimPart.Set(Util.aim.part % 5 + 1) end end,
        esp = function()
            local anyOn = false
            for _, k in ipairs(ESP_KEYS) do if V[k] then anyOn = true end end
            for _, k in ipairs(ESP_KEYS) do if ctl[k] then ctl[k].Set(not anyOn) end end
            Util.refresh()
        end,
    }

    cn(UIS.InputBegan, function(i, gp)
        if UIS:GetFocusedTextBox() or Util.listening then return end
        if Util.isBind("up", i) then FLY.kUp = true end
        if Util.isBind("down", i) then FLY.kDown = true end
        if gp then return end
        for id, fn in pairs(Util.actions) do
            if Util.isBind(id, i) then fn() end
        end
    end)
    cn(UIS.InputEnded, function(i)
        if Util.isBind("up", i) then FLY.kUp = false end
        if Util.isBind("down", i) then FLY.kDown = false end
    end)

    local AIM = {
        on = false, assist = false, mode = 1, amode = 1, part = 1, apart = 1,
        fov = 140, afov = 90, range = 400, wall = true, team = false, showFov = true, hold = true,
        lastInput = 0, rollT = 0, aimPart = nil, target = nil, label = "",
    }
    Util.aim = AIM
    local RATES = {2.6, 5.4, 9}
    local GROUPS = {
        head = {"Head"},
        body = {"UpperTorso", "Torso", "LowerTorso", "HumanoidRootPart"},
        arms = {"LeftUpperArm", "RightUpperArm", "LeftLowerArm", "RightLowerArm", "LeftHand", "RightHand", "Left Arm", "Right Arm"},
        legs = {"LeftUpperLeg", "RightUpperLeg", "LeftLowerLeg", "RightLowerLeg", "LeftFoot", "RightFoot", "Left Leg", "Right Leg"},
    }
    local ORDER = {"head", "body", "arms", "legs"}
    local rp = RaycastParams.new()
    rp.FilterType = Enum.RaycastFilterType.Exclude

    local function pickGroup(sel)
        if sel <= 4 then return ORDER[sel] end
        local pass = {}
        for _, g in ipairs(ORDER) do
            if math.random() < .5 then pass[#pass + 1] = g end
        end
        if #pass == 0 then return ORDER[math.random(1, 4)] end
        return pass[math.random(1, #pass)]
    end

    local function resolvePart(char, sel)
        local g = pickGroup(sel)
        local list = {}
        for _, n in ipairs(GROUPS[g]) do
            local p = char:FindFirstChild(n)
            if p and p:IsA("BasePart") then list[#list + 1] = p end
        end
        if #list == 0 then return char:FindFirstChild("HumanoidRootPart"), g end
        if g == "body" or g == "head" then return list[1], g end
        return list[math.random(1, #list)], g
    end

    local function visibleTo(cam, char, part)
        local ignore = {char}
        if lp.Character then ignore[2] = lp.Character end
        rp.FilterDescendantsInstances = ignore
        return workspace:Raycast(cam.CFrame.Position, part.Position - cam.CFrame.Position, rp) == nil
    end

    local function scan(cam, fovPx, prev)
        local vs = cam.ViewportSize
        local center = Vector2.new(vs.X / 2, vs.Y / 2)
        local best, bestScore
        for _, plr in ipairs(Players:GetPlayers()) do
            local ch = plr ~= lp and plr.Character
            local hum = ch and ch:FindFirstChildOfClass("Humanoid")
            local root = ch and ch:FindFirstChild("HumanoidRootPart")
            if hum and root and hum.Health > 0 and not (AIM.team and lp.Team ~= nil and plr.Team == lp.Team) then
                if (root.Position - cam.CFrame.Position).Magnitude <= AIM.range then
                    local p = cam:WorldToViewportPoint(root.Position)
                    if p.Z > 0 then
                        local sd = (Vector2.new(p.X, p.Y) - center).Magnitude
                        if sd <= fovPx * (plr == prev and 1.3 or 1) and (not AIM.wall or visibleTo(cam, ch, root)) then
                            local score = sd - (plr == prev and 40 or 0)
                            if not bestScore or score < bestScore then best, bestScore = plr, score end
                        end
                    end
                end
            end
        end
        return best
    end

    local function mkRing(thick)
        local f = new("Frame", {AnchorPoint = Vector2.new(.5, .5), Position = UDim2.fromScale(.5, .5), Size = UDim2.fromOffset(280, 280), BackgroundTransparency = 1, Visible = false}, skelLayer)
        Util.round(f, 600)
        local st = Util.stroke(f, thick, accent, .4)
        Util.acc(st, "Color")
        local g = new("UIGradient", {Transparency = NumberSequence.new({nk(0, 0), nk(.5, .75), nk(1, 0)})}, st)
        Util.loop(g, {Rotation = 360}, 7)
        return f, st
    end
    local ringBot, ringBotS = mkRing(1.6)
    local ringAss, ringAssS = mkRing(1.2)
    local reticle = new("Frame", {AnchorPoint = Vector2.new(.5, .5), Size = UDim2.fromOffset(26, 26), BackgroundTransparency = 1, Visible = false}, skelLayer)
    Util.round(reticle, 20)
    local retS = Util.stroke(reticle, 2, accent, .1)
    Util.acc(retS, "Color")
    local retDot = new("Frame", {AnchorPoint = Vector2.new(.5, .5), Position = UDim2.fromScale(.5, .5), Size = UDim2.fromOffset(4, 4), BackgroundColor3 = WHITE}, reticle)
    Util.round(retDot, 4)
    local retLabel = new("TextLabel", {AnchorPoint = Vector2.new(.5, 0), Position = UDim2.new(.5, 0, 1, 4), Size = UDim2.fromOffset(80, 14), BackgroundTransparency = 1, Font = Enum.Font.GothamBold, TextSize = 10, TextColor3 = C.text, TextStrokeTransparency = .4, Text = ""}, reticle)
    local retScale = new("UIScale", {Scale = 1}, reticle)
    local ringWas = {bot = false, ass = false}

    local function setRing(f, key, v)
        if ringWas[key] == v then return end
        ringWas[key] = v
        if v then
            f.Visible = true
            f.Size = UDim2.fromOffset(f.Size.X.Offset * .85, f.Size.Y.Offset * .85)
        else
            f.Visible = false
        end
    end

    cn(UIS.InputChanged, function(i)
        local t = i.UserInputType
        if (t == Enum.UserInputType.MouseMovement and i.Delta.Magnitude > 0)
            or t == Enum.UserInputType.Touch
            or (t == Enum.UserInputType.Gamepad1 and i.KeyCode == Enum.KeyCode.Thumbstick2) then
            AIM.lastInput = os.clock()
        end
    end)

    local retPos
    local function step(dt)
        local cam = workspace.CurrentCamera
        if not cam then return end
        local botHeld = AIM.on and (not AIM.hold or UIS.TouchEnabled or not Util.binds.hold or Util.bindDown("hold"))
        local assistLive = AIM.assist and (os.clock() - AIM.lastInput) < .22
        local useBot = botHeld
        local useAssist = not useBot and assistLive

        setRing(ringBot, "bot", AIM.on and AIM.showFov)
        setRing(ringAss, "ass", AIM.assist and AIM.showFov)
        local kf = 1 - math.exp(-dt * 12)
        if ringBot.Visible then
            local s = AIM.fov * 2
            ringBot.Size = UDim2.fromOffset(ringBot.Size.X.Offset + (s - ringBot.Size.X.Offset) * kf, ringBot.Size.Y.Offset + (s - ringBot.Size.Y.Offset) * kf)
            ringBotS.Transparency = useBot and .15 or .5
        end
        if ringAss.Visible then
            local s = AIM.afov * 2
            ringAss.Size = UDim2.fromOffset(ringAss.Size.X.Offset + (s - ringAss.Size.X.Offset) * kf, ringAss.Size.Y.Offset + (s - ringAss.Size.Y.Offset) * kf)
            ringAssS.Transparency = useAssist and .2 or .6
        end

        if not (useBot or useAssist) then
            AIM.target = nil
            reticle.Visible = false
            return
        end

        local fovPx = useBot and AIM.fov or AIM.afov
        local prev = AIM.target
        local plr = scan(cam, fovPx, prev)
        if plr ~= prev then
            AIM.target = plr
            AIM.aimPart = nil
            if plr then
                reticle.Visible = true
                retScale.Scale = 1.8
                tw(retScale, {Scale = 1}, .35, EASE.Back)
            end
        end
        local ch = plr and plr.Character
        if not ch then
            reticle.Visible = false
            return
        end

        AIM.rollT -= dt
        local sel = useBot and AIM.part or AIM.apart
        if not AIM.aimPart or not AIM.aimPart.Parent or AIM.rollT <= 0 then
            local p, g = resolvePart(ch, sel)
            AIM.aimPart, AIM.label = p, g
            AIM.rollT = .8 + math.random() * .8
        end
        local part = AIM.aimPart
        if not part then return end

        local tp = part.Position + part.AssemblyLinearVelocity * .05
        local mode = useBot and AIM.mode or AIM.amode
        local rate = RATES[mode] * (useBot and 1 or .55)
        local cf = cam.CFrame
        cam.CFrame = cf:Lerp(CFrame.lookAt(cf.Position, tp), 1 - math.exp(-dt * rate))

        local sp = cam:WorldToViewportPoint(part.Position)
        if sp.Z > 0 then
            local goal = Vector2.new(sp.X, sp.Y)
            retPos = retPos and retPos:Lerp(goal, 1 - math.exp(-dt * 20)) or goal
            reticle.Position = UDim2.fromOffset(retPos.X, retPos.Y)
            reticle.Rotation = (os.clock() * 90) % 360
            retLabel.Rotation = -reticle.Rotation
            retLabel.Text = AIM.showLabel == false and "" or string.upper(AIM.label)
            reticle.Visible = true
        else
            reticle.Visible = false
        end
    end
    RS:BindToRenderStep("AuraAimLoop", Enum.RenderPriority.Camera.Value + 2, step)

    Util.cleanups[#Util.cleanups + 1] = function()
        pcall(function() RS:UnbindFromRenderStep("AuraAimLoop") end)
        FLY.on = false
        flyStop()
        Util.noclipSet(false)
    end
end

do
    local Util = __AuraFixUtil
    local new = Util.new
    local nk = NumberSequenceKeypoint.new
    local kp = ColorSequenceKeypoint.new
    local tau = math.pi * 2

    local AM = {
        on = false, orbs = true, halo = true, sigil = true, wings = true, motes = true, trails = true, ripples = true,
        power = 100, speed = 100, orbCount = 5, colorMode = 1,
        pillar = true, helix = true, arcs = true, ghosts = true, waves = true, music = true, flash = 0, waveT = 2,
    }
    Util.auraMe = AM

    local folder
    local fx = {}
    local movers, moverCF = {}, {}
    local colorParts = {}
    local colorT = 0
    local rippleT = 0
    local groundY = 0
    local groundSmooth
    local t0 = os.clock()
    local ghostT = 0

    local rp = RaycastParams.new()
    rp.FilterType = Enum.RaycastFilterType.Exclude

    local function palette(t, i)
        local mode = AM.colorMode
        if mode == 3 then
            return Color3.fromHSV((t * .12 + (i or 0) * .07) % 1, .62, 1)
        elseif mode == 2 then
            local k = (math.sin(t * .8 + (i or 0) * .6) + 1) / 2
            return accent:Lerp(Util.shift(accent), k)
        end
        return accent
    end

    local function mkPart(size, shape, name)
        local p = Instance.new("Part")
        p.Name = name or "AuraMePart"
        p.Anchored = true
        p.CanCollide = false
        p.CanQuery = false
        p.CanTouch = false
        p.CastShadow = false
        p.Massless = true
        p.Material = Enum.Material.Neon
        p.Size = size
        p.Shape = shape or Enum.PartType.Block
        p.TopSurface = Enum.SurfaceType.Smooth
        p.BottomSurface = Enum.SurfaceType.Smooth
        p.Color = accent
        p.Parent = folder
        return p
    end

    local function track(p, role, idx)
        colorParts[#colorParts + 1] = {part = p, role = role, idx = idx or 0}
        return p
    end

    local function attachment(parent, pos)
        local a = Instance.new("Attachment")
        a.Position = pos or Vector3.zero
        a.Parent = parent
        return a
    end

    local function clearFx()
        for _, group in pairs(fx) do
            if type(group) == "table" and group.destroy then pcall(group.destroy) end
        end
        table.clear(fx)
        table.clear(movers)
        table.clear(moverCF)
        table.clear(colorParts)
        if folder then pcall(function() folder:Destroy() end) folder = nil end
    end

    local function addMover(p)
        movers[#movers + 1] = p
        return #movers
    end

    local function buildOrbs(root)
        local group = {items = {}}
        local n = AM.orbCount
        for i = 1, n do
            local orb = track(mkPart(Vector3.new(.5, .5, .5), Enum.PartType.Ball, "AuraOrb"), "main", i)
            local light = Instance.new("PointLight")
            light.Range, light.Brightness, light.Color = 6, 1.2, accent
            light.Parent = orb
            local a0 = attachment(orb, Vector3.new(0, 0, -.2))
            local a1 = attachment(orb, Vector3.new(0, 0, .2))
            local trail = Instance.new("Trail")
            trail.Attachment0, trail.Attachment1 = a0, a1
            trail.Lifetime = .55
            trail.LightEmission = 1
            trail.Transparency = NumberSequence.new({nk(0, .15), nk(1, 1)})
            trail.WidthScale = NumberSequence.new({nk(0, 1), nk(1, 0)})
            trail.Color = ColorSequence.new(accent)
            trail.Parent = orb
            group.items[i] = {part = orb, idx = addMover(orb), light = light, trail = trail, phase = (i - 1) / n * tau}
        end
        group.arcs = {}
        if AM.arcs then
            group.rootAtt = attachment(root, Vector3.new(0, .4, 0))
            for i = 1, n do
                local b = Instance.new("Beam")
                b.Attachment0 = group.rootAtt
                b.Attachment1 = attachment(group.items[i].part)
                b.Segments = 14
                b.FaceCamera = true
                b.LightEmission = 1
                b.Width0, b.Width1 = .06, .1
                b.Transparency = NumberSequence.new(.35)
                b.Color = ColorSequence.new(accent)
                b.Parent = root
                group.arcs[i] = b
            end
        end
        group.beams = {}
        for i = 1, n do
            local a = group.items[i].part
            local b = group.items[i % n + 1].part
            local beam = Instance.new("Beam")
            beam.Attachment0 = attachment(a)
            beam.Attachment1 = attachment(b)
            beam.Width0, beam.Width1 = .07, .07
            beam.LightEmission = 1
            beam.FaceCamera = true
            beam.Transparency = NumberSequence.new({nk(0, .55), nk(.5, .8), nk(1, .55)})
            beam.Color = ColorSequence.new(accent)
            beam.Parent = a
            group.beams[i] = beam
        end
        function group.update(t, dt, cf, k)
            local sp = AM.speed / 100
            local r = 3.1 + math.sin(t * .9 * sp) * .35
            for i, o in ipairs(group.items) do
                local ang = t * 1.25 * sp + o.phase
                local y = .4 + math.sin(t * 1.7 * sp + i * 1.3) * 1.15 + math.sin(ang * .5) * .4
                local pos = cf * Vector3.new(math.cos(ang) * r, y, math.sin(ang) * r)
                local sz = (.42 + .12 * math.sin(t * 3 + i)) * k
                o.part.Size = Vector3.new(sz, sz, sz)
                moverCF[o.idx] = CFrame.new(pos)
                o.light.Brightness = 1.2 * k
                o.trail.Lifetime = .45 + .25 * sp
            end
            group.jt = (group.jt or 0) - dt
            if group.jt <= 0 then
                group.jt = .04
                for _, b in ipairs(group.arcs) do
                    b.CurveSize0 = (math.random() - .5) * 4
                    b.CurveSize1 = (math.random() - .5) * 4
                    b.Width0 = .03 + math.random() * .08
                    b.Transparency = NumberSequence.new(.2 + math.random() * .5)
                end
            end
        end
        function group.recolor(c1, c2)
            for i, o in ipairs(group.items) do
                local c = palette(os.clock() - t0, i)
                o.light.Color = c
                o.trail.Color = ColorSequence.new(c, c2)
            end
            for _, b in ipairs(group.beams) do b.Color = ColorSequence.new(c1, c2) end
            for _, b in ipairs(group.arcs) do b.Color = ColorSequence.new(c1, c2) end
        end
        function group.destroy()
            for _, b in ipairs(group.arcs) do pcall(function() b:Destroy() end) end
            if group.rootAtt then pcall(function() group.rootAtt:Destroy() end) end
        end
        fx.orbs = group
    end

    local function buildHalo()
        local group = {segs = {}}
        local N = 26
        for i = 1, N do
            local p = track(mkPart(Vector3.new(.34, .07, .1), nil, "AuraHalo"), "main", i)
            group.segs[i] = {part = p, idx = addMover(p), a = (i - 1) / N * tau}
        end
        local sparkle = {}
        for i = 1, 4 do
            local s = track(mkPart(Vector3.new(.16, .16, .16), Enum.PartType.Ball, "AuraHaloSpark"), "light", i)
            sparkle[i] = {part = s, idx = addMover(s), a = (i - 1) / 4 * tau}
        end
        group.sparkle = sparkle
        function group.update(t, dt, cf, k)
            local sp = AM.speed / 100
            local pulse = 1 + math.sin(t * 2.4 * sp) * .06
            local R = 1.35 * pulse * (.8 + .2 * k)
            local y = 3.55 + math.sin(t * 1.6 * sp) * .12
            local spin = t * .9 * sp
            for i, s in ipairs(group.segs) do
                local a = s.a + spin
                local pos = cf * Vector3.new(math.cos(a) * R, y, math.sin(a) * R)
                local look = cf * Vector3.new(math.cos(a) * (R + 1), y, math.sin(a) * (R + 1))
                moverCF[s.idx] = CFrame.lookAt(pos, look)
                s.part.Transparency = .12 + .2 * (1 - (math.sin(a * 2 - t * 3) + 1) / 2)
            end
            for i, s in ipairs(group.sparkle) do
                local a = -s.a - spin * 2.2
                local pos = cf * Vector3.new(math.cos(a) * (R + .15), y + math.sin(t * 5 + i * 2) * .18, math.sin(a) * (R + .15))
                moverCF[s.idx] = CFrame.new(pos)
                local sz = .12 + .1 * math.abs(math.sin(t * 4 + i))
                s.part.Size = Vector3.new(sz, sz, sz)
            end
        end
        fx.halo = group
    end

    local function buildSigil()
        local group = {rings = {}, spokes = {}}
        local function ring(count, radius, size, role)
            local list = {}
            for i = 1, count do
                local p = track(mkPart(size, nil, "AuraSigil"), role, i)
                p.Transparency = .25
                list[i] = {part = p, idx = addMover(p), a = (i - 1) / count * tau}
            end
            return {list = list, radius = radius, count = count}
        end
        group.rings[1] = ring(40, 4.6, Vector3.new(.12, .06, .5), "main")
        group.rings[2] = ring(28, 3.3, Vector3.new(.1, .06, .4), "light")
        group.rings[3] = ring(16, 1.9, Vector3.new(.09, .06, .3), "main")
        group.disc = track(mkPart(Vector3.new(.05, 9, 9), Enum.PartType.Cylinder, "AuraDisc"), "main", 1)
        group.disc.Transparency = .86
        group.discIdx = addMover(group.disc)
        for tri = 0, 1 do
            for e = 1, 3 do
                local p = track(mkPart(Vector3.new(.09, .06, 1), nil, "AuraSigilLine"), "light", e + tri * 3)
                p.Transparency = .18
                group.spokes[#group.spokes + 1] = {part = p, idx = addMover(p), tri = tri, e = e}
            end
        end
        for i = 1, 6 do
            local p = track(mkPart(Vector3.new(.22, .06, .22), nil, "AuraRune"), "main", i)
            group.spokes[#group.spokes + 1] = {part = p, idx = addMover(p), rune = i}
        end
        function group.update(t, dt, cf, k)
            local sp = AM.speed / 100
            local base = Vector3.new(cf.Position.X, groundY + .06, cf.Position.Z)
            local grow = math.clamp(k, .3, 1.4)
            local fl = AM.flash or 0
            local dsz = (8.4 + math.sin(t * 1.6 * sp) * .5 + fl * 2) * grow
            group.disc.Size = Vector3.new(.05, dsz, dsz)
            group.disc.Transparency = math.clamp(.88 - fl * .3 + math.sin(t * 2 * sp) * .02, .45, .95)
            moverCF[group.discIdx] = CFrame.new(base.X, base.Y - .03, base.Z) * CFrame.Angles(0, 0, math.rad(90))
            for ri, rg in ipairs(group.rings) do
                local dir = ri == 2 and -1 or 1
                local spin = t * (.35 + ri * .12) * sp * dir
                local R = rg.radius * grow * (1 + math.sin(t * 1.4 * sp + ri) * .015)
                for _, s in ipairs(rg.list) do
                    local a = s.a + spin
                    local pos = base + Vector3.new(math.cos(a) * R, 0, math.sin(a) * R)
                    moverCF[s.idx] = CFrame.lookAt(pos, pos + Vector3.new(-math.sin(a), 0, math.cos(a)))
                    local w = (math.sin(a * 3 - t * 2.2 * sp) + 1) / 2
                    s.part.Transparency = math.max(0, .12 + (1 - w) * .5 - fl * .3)
                end
            end
            local R = 4.3 * grow
            local spin = t * .5 * sp
            for _, s in ipairs(group.spokes) do
                if s.tri then
                    local a1 = spin + s.tri * math.pi / 3 + (s.e - 1) / 3 * tau
                    local a2 = spin + s.tri * math.pi / 3 + s.e / 3 * tau
                    local p1 = base + Vector3.new(math.cos(a1) * R, 0, math.sin(a1) * R)
                    local p2 = base + Vector3.new(math.cos(a2) * R, 0, math.sin(a2) * R)
                    local mid = (p1 + p2) / 2
                    local len = (p2 - p1).Magnitude
                    s.part.Size = Vector3.new(.09, .06, len)
                    moverCF[s.idx] = CFrame.lookAt(mid, p2)
                else
                    local a = -spin * 1.6 + (s.rune - 1) / 6 * tau
                    local pos = base + Vector3.new(math.cos(a) * 2.6 * grow, .02, math.sin(a) * 2.6 * grow)
                    moverCF[s.idx] = CFrame.new(pos) * CFrame.Angles(0, a + t, 0)
                    local pulse = .2 + .5 * (math.sin(t * 3 + s.rune) + 1) / 2
                    s.part.Transparency = pulse
                end
            end
        end
        fx.sigil = group
    end

    local function buildWings()
        local group = {sides = {-1, 1}, feathers = {}}
        local COUNT = 10
        for _, side in ipairs(group.sides) do
            for i = 1, COUNT do
                local len = 3.4 - (i - 1) * .26
                local p = track(mkPart(Vector3.new(.2, len, .05), nil, "AuraWing"), "wing", i)
                group.feathers[#group.feathers + 1] = {part = p, idx = addMover(p), side = side, i = i, len = len}
            end
        end
        function group.update(t, dt, cf, k, speedRatio)
            local sp = AM.speed / 100
            local flap = math.sin(t * (2.2 + speedRatio * 3) * sp)
            local flap2 = math.sin(t * (2.2 + speedRatio * 3) * sp - .6)
            local open = .55 + .12 * flap + speedRatio * .25
            for _, f in ipairs(group.feathers) do
                local spread = math.rad(6 + (f.i - 1) * 10.5 + (f.i * 3) * flap2) * (1 + open * .6)
                local pivot = cf * CFrame.new(f.side * .3, .55, .62)
                local swing = CFrame.Angles(0, f.side * math.rad(-28 - speedRatio * 14 + flap * 6), f.side * -(math.rad(18) + spread))
                local tip = CFrame.new(0, f.len / 2, 0)
                moverCF[f.idx] = pivot * swing * tip
                f.part.Transparency = .1 + (f.i - 1) * .06 + (1 - k) * .3
            end
        end
        fx.wings = group
    end

    local function buildMotes(root, torso)
        local group = {}
        local e1 = Instance.new("ParticleEmitter")
        e1.Name = "AuraMotes"
        e1.Texture = "rbxasset://textures/particles/sparkles_main.dds"
        e1.Rate = 28
        e1.Lifetime = NumberRange.new(1.2, 2.2)
        e1.Speed = NumberRange.new(.4, 1.6)
        e1.SpreadAngle = Vector2.new(180, 180)
        e1.Acceleration = Vector3.new(0, 2.2, 0)
        e1.Drag = 1.2
        e1.LightEmission = 1
        e1.Size = NumberSequence.new({nk(0, 0), nk(.25, .28), nk(1, 0)})
        e1.Transparency = NumberSequence.new({nk(0, 1), nk(.15, .1), nk(1, 1)})
        e1.Color = ColorSequence.new(accent)
        e1.Rotation = NumberRange.new(0, 360)
        e1.RotSpeed = NumberRange.new(-60, 60)
        e1.Shape = Enum.ParticleEmitterShape.Cylinder
        e1.ShapeInOut = Enum.ParticleEmitterShapeInOut.Outward
        e1.Parent = torso
        local e2 = Instance.new("ParticleEmitter")
        e2.Name = "AuraMist"
        e2.Texture = "rbxasset://textures/particles/smoke_main.dds"
        e2.Rate = 9
        e2.Lifetime = NumberRange.new(1.6, 2.6)
        e2.Speed = NumberRange.new(.2, .8)
        e2.SpreadAngle = Vector2.new(180, 180)
        e2.LightEmission = .8
        e2.LightInfluence = 0
        e2.Size = NumberSequence.new({nk(0, 1.4), nk(1, 3.2)})
        e2.Transparency = NumberSequence.new({nk(0, 1), nk(.3, .86), nk(1, 1)})
        e2.Color = ColorSequence.new(accent)
        e2.Parent = root
        local light = Instance.new("PointLight")
        light.Range, light.Brightness, light.Color, light.Shadows = 16, 1.6, accent, false
        light.Parent = root
        local hl = Instance.new("Highlight")
        hl.Name = "AuraMeGlow"
        hl.DepthMode = Enum.HighlightDepthMode.Occluded
        hl.FillColor, hl.OutlineColor = accent, accent
        hl.FillTransparency, hl.OutlineTransparency = .88, .35
        hl.Adornee = lp.Character
        hl.Parent = folder
        group.e1, group.e2, group.light, group.hl = e1, e2, light, hl
        function group.update(t, dt, cf, k, speedRatio)
            local sp = AM.speed / 100
            e1.Rate = 28 * k * (1 + speedRatio)
            e2.Rate = 9 * k
            light.Brightness = (1.3 + math.sin(t * 2.6 * sp) * .45) * k
            light.Range = 14 + math.sin(t * 1.3 * sp) * 2.5
            hl.OutlineTransparency = .35 + (1 - k) * .4 + (math.sin(t * 3.1 * sp) + 1) * .08
            hl.FillTransparency = .9 - .05 * math.sin(t * 2 * sp)
        end
        function group.recolor(c1, c2)
            local seq = ColorSequence.new(c1, c2)
            e1.Color, e2.Color = seq, seq
            light.Color = c1
            hl.FillColor, hl.OutlineColor = c1, c2
        end
        function group.destroy()
            for _, o in ipairs({e1, e2, light, hl}) do pcall(function() o:Destroy() end) end
        end
        fx.motes = group
    end

    local function buildTrails(ch)
        local group = {trails = {}, objs = {}}
        local anchors = {
            {"RightHand", "Right Arm"}, {"LeftHand", "Left Arm"},
            {"RightFoot", "Right Leg"}, {"LeftFoot", "Left Leg"},
        }
        for _, names in ipairs(anchors) do
            local part = ch:FindFirstChild(names[1]) or ch:FindFirstChild(names[2])
            if part then
                local a0 = attachment(part, Vector3.new(0, -.25, -.12))
                local a1 = attachment(part, Vector3.new(0, -.25, .12))
                local tr = Instance.new("Trail")
                tr.Attachment0, tr.Attachment1 = a0, a1
                tr.Lifetime = .6
                tr.MinLength = .05
                tr.LightEmission = 1
                tr.FaceCamera = true
                tr.Transparency = NumberSequence.new({nk(0, .2), nk(.6, .7), nk(1, 1)})
                tr.WidthScale = NumberSequence.new({nk(0, 1), nk(1, 0)})
                tr.Color = ColorSequence.new(accent)
                tr.Parent = part
                group.trails[#group.trails + 1] = tr
                group.objs[#group.objs + 1] = a0
                group.objs[#group.objs + 1] = a1
                group.objs[#group.objs + 1] = tr
            end
        end
        function group.update(t, dt, cf, k)
            for _, tr in ipairs(group.trails) do tr.Lifetime = (.35 + .35 * AM.speed / 100) * k end
        end
        function group.recolor(c1, c2)
            for _, tr in ipairs(group.trails) do tr.Color = ColorSequence.new(c1, c2) end
        end
        function group.destroy()
            for _, o in ipairs(group.objs) do pcall(function() o:Destroy() end) end
        end
        fx.trails = group
    end

    local function spawnRipple(pos, c, big)
        local ring = mkPart(Vector3.new(.05, 1, 1), Enum.PartType.Cylinder, "AuraRipple")
        ring.Color = c
        ring.Transparency = .35
        ring.CFrame = CFrame.new(pos.X, groundY + .08, pos.Z) * CFrame.Angles(0, 0, math.rad(90))
        local grow = big and 17 or (6.5 + math.random() * 2)
        if big then ring.Transparency = .2 end
        local info = TweenInfo.new(big and 1.3 or .9, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
        TS:Create(ring, info, {Size = Vector3.new(.05, grow, grow), Transparency = 1}):Play()
        task.delay(big and 1.4 or .95, function() if ring.Parent then ring:Destroy() end end)
    end

    local function buildPillar()
        local g = {layers = {}}
        for i, d in ipairs({{14, 1.3, .78}, {14, 2.2, .88}, {14, 3.4, .94}}) do
            local p = track(mkPart(Vector3.new(d[1], d[2], d[2]), Enum.PartType.Cylinder, "AuraPillar"), "main", i)
            p.Transparency = d[3]
            g.layers[i] = {part = p, idx = addMover(p), h = d[1], d = d[2], tr = d[3]}
        end
        local em = Instance.new("ParticleEmitter")
        em.Texture = "rbxasset://textures/particles/sparkles_main.dds"
        em.Rate = 22
        em.Lifetime = NumberRange.new(1, 1.8)
        em.Speed = NumberRange.new(5, 9)
        em.EmissionDirection = Enum.NormalId.Right
        em.SpreadAngle = Vector2.new(6, 6)
        em.LightEmission = 1
        em.Size = NumberSequence.new({nk(0, .1), nk(.3, .32), nk(1, 0)})
        em.Transparency = NumberSequence.new({nk(0, 1), nk(.2, .15), nk(1, 1)})
        em.Color = ColorSequence.new(accent)
        em.Parent = g.layers[1].part
        function g.update(t, dt, cf, k)
            local sp = AM.speed / 100
            local base = Vector3.new(cf.Position.X, groundY, cf.Position.Z)
            for i, l in ipairs(g.layers) do
                local pulse = (1 + math.sin(t * (1.6 + i * .5) * sp + i) * .1) * (.7 + .3 * k)
                l.part.Size = Vector3.new(l.h, l.d * pulse, l.d * pulse)
                moverCF[l.idx] = CFrame.new(base.X, base.Y + l.h / 2, base.Z) * CFrame.Angles(0, 0, math.rad(90))
                l.part.Transparency = math.clamp(l.tr - (k - 1) * .06 + math.sin(t * 2 + i) * .03, .5, .98)
            end
            em.Rate = 22 * k
        end
        function g.recolor(c1, c2) em.Color = ColorSequence.new(c1, c2) end
        function g.destroy() pcall(function() em:Destroy() end) end
        fx.pillar = g
    end

    local function buildHelix()
        local g = {pts = {}}
        for s = 1, 2 do
            for i = 1, 14 do
                local p = track(mkPart(Vector3.new(.2, .2, .2), Enum.PartType.Ball, "AuraHelix"), "light", i)
                g.pts[#g.pts + 1] = {part = p, idx = addMover(p), s = s, i = i}
            end
        end
        function g.update(t, dt, cf, k)
            local sp = AM.speed / 100
            for _, h in ipairs(g.pts) do
                local u = (t * .3 * sp + h.i / 14) % 1
                local edge = math.abs(u * 2 - 1)
                local ang = u * math.pi * 4.4 + t * 2 * sp + h.s * math.pi
                local r = 1.9 + .25 * math.sin(t + h.i)
                moverCF[h.idx] = CFrame.new(cf * Vector3.new(math.cos(ang) * r, -2.6 + u * 7.4, math.sin(ang) * r))
                local sz = .24 * (1 - edge * .7) * k
                h.part.Size = Vector3.new(sz, sz, sz)
                h.part.Transparency = .1 + edge * .6
            end
        end
        fx.helix = g
    end

    local function spawnGhost(ch, c)
        if not folder or #folder:GetChildren() > 420 then return end
        for _, p in ipairs(ch:GetChildren()) do
            if p:IsA("BasePart") and p.Name ~= "HumanoidRootPart" and p.Transparency < 1 then
                local g = p:Clone()
                for _, d in ipairs(g:GetChildren()) do
                    if not d:IsA("SpecialMesh") then d:Destroy() end
                end
                g.Anchored, g.CanCollide, g.CanQuery, g.CanTouch, g.Massless, g.CastShadow = true, false, false, false, true, false
                g.Material = Enum.Material.Neon
                g.Color = c
                g.Transparency = .55
                if g:IsA("MeshPart") then g.TextureID = "" end
                g.CFrame = p.CFrame
                g.Parent = folder
                TS:Create(g, TweenInfo.new(.55, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Transparency = 1}):Play()
                task.delay(.6, function() if g.Parent then g:Destroy() end end)
            end
        end
    end

    function Util.auraBurst()
        if not (AM.on and folder) then return end
        local ch = lp.Character
        local root = ch and ch:FindFirstChild("HumanoidRootPart")
        if not root then return end
        for i = 1, 3 do
            task.delay((i - 1) * .16, function()
                if AM.on and folder then spawnRipple(root.Position, palette(os.clock() - t0, i), true) end
            end)
        end
        if fx.motes then fx.motes.e1:Emit(90) end
        AM.flash = 1
    end

    local function rebuild()
        clearFx()
        if not AM.on then return end
        local ch = lp.Character
        local root = ch and ch:FindFirstChild("HumanoidRootPart")
        local torso = ch and (ch:FindFirstChild("UpperTorso") or ch:FindFirstChild("Torso") or root)
        if not (ch and root) then return end
        folder = Instance.new("Folder")
        folder.Name = "AuraMeFX"
        folder.Parent = workspace
        if AM.orbs then buildOrbs(root) end
        if AM.halo then buildHalo() end
        if AM.sigil then buildSigil() end
        if AM.wings then buildWings() end
        if AM.motes then buildMotes(root, torso) end
        if AM.trails then buildTrails(ch) end
        if AM.pillar then buildPillar() end
        if AM.helix then buildHelix() end
        fx.ripples = AM.ripples and {} or nil
    end
    Util.auraMeRebuild = rebuild

    function Util.auraMeSet(v)
        AM.on = v and true or false
        rebuild()
        if AM.on then
            Util.toast("Aura.Me включена", C.good)
            task.delay(.15, Util.auraBurst)
        end
    end

    cn(lp.CharacterAdded, function(ch)
        if not AM.on then return end
        task.spawn(function()
            ch:WaitForChild("HumanoidRootPart", 6)
            task.wait(.5)
            if AM.on then rebuild() end
        end)
    end)

    local lastPos
    local function step(dt)
        if not AM.on or not folder then return end
        local ch = lp.Character
        local root = ch and ch:FindFirstChild("HumanoidRootPart")
        if not root then return end
        local t = os.clock() - t0
        local meter = AM.music and __AuraFix_audioMeter
        local beat = meter and meter.beat or 0
        local k = AM.power / 100 * (1 + beat * .45)
        AM.flash = math.max(0, (AM.flash or 0) - dt * 1.6)

        rp.FilterDescendantsInstances = {ch, folder}
        local hit = workspace:Raycast(root.Position, Vector3.new(0, -14, 0), rp)
        local gy = hit and hit.Position.Y or (root.Position.Y - 3)
        groundSmooth = groundSmooth and groundSmooth + (gy - groundSmooth) * (1 - math.exp(-dt * 14)) or gy
        groundY = groundSmooth

        local vel = root.AssemblyLinearVelocity
        local speedRatio = math.clamp(Vector3.new(vel.X, 0, vel.Z).Magnitude / 24, 0, 1)
        local cf = CFrame.new(root.Position) * (root.CFrame - root.CFrame.Position)
        local flat = CFrame.new(root.Position) * CFrame.Angles(0, math.atan2(-root.CFrame.LookVector.X, -root.CFrame.LookVector.Z), 0)

        for name, group in pairs(fx) do
            if type(group) == "table" and group.update then
                local base = (name == "wings") and cf or flat
                group.update(t, dt, base, k, speedRatio)
            end
        end

        if #movers > 0 then
            workspace:BulkMoveTo(movers, moverCF, Enum.BulkMoveMode.FireCFrameChanged)
        end

        colorT -= dt
        if colorT <= 0 then
            colorT = .05
            local c1 = palette(t, 0)
            local c2 = Util.shift(c1)
            for _, entry in ipairs(colorParts) do
                local p = entry.part
                if p.Parent then
                    local c = palette(t, entry.idx)
                    if entry.role == "light" then c = c:Lerp(WHITE, .45)
                    elseif entry.role == "wing" then c = c:Lerp(c2, (entry.idx - 1) / 10) end
                    p.Color = c
                end
            end
            for _, group in pairs(fx) do
                if type(group) == "table" and group.recolor then group.recolor(c1, c2) end
            end
        end

        if AM.waves then
            AM.waveT -= dt
            if AM.waveT <= 0 then
                AM.waveT = 3.2 / math.max(AM.speed / 100, .4)
                AM.flash = 1
                spawnRipple(root.Position, palette(t, 2), true)
                if fx.motes then fx.motes.e1:Emit(24) end
            end
        end
        if AM.ghosts and speedRatio > .3 then
            ghostT -= dt
            if ghostT <= 0 then
                ghostT = .09
                spawnGhost(ch, palette(t, math.random(1, 5)))
            end
        end

        if AM.ripples and fx.ripples then
            rippleT -= dt
            local moving = speedRatio > .08 and hit ~= nil
            if rippleT <= 0 and moving then
                rippleT = .42 - speedRatio * .2
                spawnRipple(root.Position, palette(t, 1))
            end
        end
    end
    RS:BindToRenderStep("AuraMeLoop", Enum.RenderPriority.Character.Value + 5, step)

    Util.cleanups[#Util.cleanups + 1] = function()
        pcall(function() RS:UnbindFromRenderStep("AuraMeLoop") end)
        AM.on = false
        clearFx()
    end
end

do
    local Util = __AuraFixUtil
    local new = Util.new
    local kp, nk = ColorSequenceKeypoint.new, NumberSequenceKeypoint.new
    local BLACK = Color3.new(0, 0, 0)

    local RTX = {
        mode = 0, k = 1, modes = {}, fx = {}, tweens = {}, refl = {}, lights = {}, ctx = nil, t0 = os.clock(),
        opt = {letterbox = true, flare = true, sway = true, reflect = true, overlay = true},
        clockCur = 12, clockTarget = 12, clockAmp = 0, clockSpeed = .05,
        vig = 0, vigTarget = 0, bars = 0, barsTarget = 0, reflToken = 0, adapt = 0,
    }
    Util.rtx = RTX

    local LIGHT_KEYS = {
        "Brightness", "Ambient", "OutdoorAmbient", "ColorShift_Top", "ColorShift_Bottom",
        "EnvironmentDiffuseScale", "EnvironmentSpecularScale", "ExposureCompensation",
        "ShadowSoftness", "FogColor", "FogEnd", "FogStart", "GeographicLatitude",
    }
    local DEFAULTS = {
        bloom = {Intensity = 0, Size = 24, Threshold = 1},
        cc = {Brightness = 0, Contrast = 0, Saturation = 0, TintColor = WHITE},
        rays = {Intensity = 0, Spread = .5},
        dof = {FarIntensity = 0, NearIntensity = 0, FocusDistance = 50, InFocusRadius = 30},
        atmo = {Density = 0, Offset = 0, Color = Color3.fromRGB(199, 199, 199), Decay = Color3.fromRGB(106, 112, 125), Glare = 0, Haze = 0},
    }
    local rayP = RaycastParams.new()
    rayP.FilterType = Enum.RaycastFilterType.Exclude

    local function merge(base, over)
        local o = {}
        for k, v in pairs(base) do o[k] = v end
        for k, v in pairs(over or {}) do o[k] = v end
        return o
    end
    RTX.merge = merge

    local function tweenTo(inst, props, dur)
        if not inst or not props or next(props) == nil then return end
        local ok, tween = pcall(function()
            return TS:Create(inst, TweenInfo.new(dur, EASE.Sine, DIR.InOut), props)
        end)
        if ok and tween then
            tween:Play()
        else
            for k, v in pairs(props) do pcall(function() inst[k] = v end) end
        end
    end
    RTX.tweenTo = tweenTo

    local function mkFx(class, name, props)
        local o = Instance.new(class)
        o.Name = name
        for k, v in pairs(props) do pcall(function() o[k] = v end) end
        o.Parent = Lighting
        return o
    end

    local function ensureFx()
        local fx = RTX.fx
        if not fx.bloom then fx.bloom = mkFx("BloomEffect", "AuraRTX_Bloom", DEFAULTS.bloom) end
        if not fx.cc then fx.cc = mkFx("ColorCorrectionEffect", "AuraRTX_CC", DEFAULTS.cc) end
        if not fx.flash then fx.flash = mkFx("ColorCorrectionEffect", "AuraRTX_Flash", DEFAULTS.cc) end
        if not fx.rays then fx.rays = mkFx("SunRaysEffect", "AuraRTX_Rays", DEFAULTS.rays) end
        if not fx.dof then fx.dof = mkFx("DepthOfFieldEffect", "AuraRTX_DOF", DEFAULTS.dof) end
        if not fx.atmo then
            local existing = Lighting:FindFirstChildOfClass("Atmosphere")
            if existing then
                fx.atmo, fx.atmoOwn = existing, false
                fx.atmoSnap = {Density = existing.Density, Offset = existing.Offset, Color = existing.Color, Decay = existing.Decay, Glare = existing.Glare, Haze = existing.Haze}
            else
                fx.atmo, fx.atmoOwn = mkFx("Atmosphere", "AuraRTX_Atmo", DEFAULTS.atmo), true
            end
        end
    end

    local function snapshot()
        RTX.snap = {ClockTime = Lighting.ClockTime}
        for _, key in ipairs(LIGHT_KEYS) do
            pcall(function() RTX.snap[key] = Lighting[key] end)
        end
        local terrain = workspace:FindFirstChildOfClass("Terrain")
        if terrain then
            RTX.terrainSnap = {WaterReflectance = terrain.WaterReflectance, WaterTransparency = terrain.WaterTransparency, WaterWaveSize = terrain.WaterWaveSize}
        end
    end

    local function vigEdge(sg, pos, size, anchor, rot)
        local f = new("Frame", {BackgroundColor3 = BLACK, BackgroundTransparency = 1, AnchorPoint = anchor, Position = pos, Size = size}, sg)
        new("UIGradient", {Rotation = rot, Transparency = NumberSequence.new({nk(0, 0), nk(.5, .55), nk(1, 1)})}, f)
        return f
    end

    local function buildOverlay()
        local sg = new("ScreenGui", {Name = "AuraRTXOverlay", ResetOnSpawn = false, IgnoreGuiInset = true, DisplayOrder = 4, ZIndexBehavior = Enum.ZIndexBehavior.Sibling}, pgui)
        RTX.sg = sg
        RTX.layer = new("CanvasGroup", {Name = "ModeLayer", BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1)}, sg)
        RTX.vigs = {
            vigEdge(sg, UDim2.fromScale(.5, 0), UDim2.fromScale(1, .32), Vector2.new(.5, 0), 90),
            vigEdge(sg, UDim2.fromScale(.5, 1), UDim2.fromScale(1, .32), Vector2.new(.5, 1), 270),
            vigEdge(sg, UDim2.fromScale(0, .5), UDim2.fromScale(.26, 1), Vector2.new(0, .5), 0),
            vigEdge(sg, UDim2.fromScale(1, .5), UDim2.fromScale(.26, 1), Vector2.new(1, .5), 180),
        }
        RTX.barTop = new("Frame", {BackgroundColor3 = BLACK, Size = UDim2.fromScale(1, 0)}, sg)
        RTX.barBot = new("Frame", {AnchorPoint = Vector2.new(0, 1), Position = UDim2.fromScale(0, 1), BackgroundColor3 = BLACK, Size = UDim2.fromScale(1, 0)}, sg)
        RTX.flashF = new("Frame", {BackgroundColor3 = WHITE, BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1), ZIndex = 5}, sg)
    end

    function RTX.chroma(layer, a)
        for side = 1, 2 do
            local left = side == 1
            local f = new("Frame", {AnchorPoint = Vector2.new(left and 0 or 1, 0), Position = UDim2.fromScale(left and 0 or 1, 0), Size = UDim2.fromScale(.045, 1), BackgroundColor3 = left and Color3.fromRGB(255, 60, 60) or Color3.fromRGB(60, 200, 255), BackgroundTransparency = 1 - a}, layer)
            new("UIGradient", {Rotation = left and 0 or 180, Transparency = NumberSequence.new({nk(0, 0), nk(1, 1)})}, f)
        end
    end

    function RTX.circle(parent, size, pos, color, fillTr, strokeTr)
        local f = new("Frame", {AnchorPoint = Vector2.new(.5, .5), Position = pos, Size = UDim2.fromOffset(size, size), BackgroundColor3 = color, BackgroundTransparency = fillTr}, parent)
        Util.round(f, size)
        if strokeTr then Util.stroke(f, 1.2, color, strokeTr) end
        return f
    end

    function RTX.focusDistance(cam)
        rayP.FilterDescendantsInstances = {lp.Character, RTX.folder}
        local hit = workspace:Raycast(cam.CFrame.Position, cam.CFrame.LookVector * 400, rayP)
        return hit and (hit.Position - cam.CFrame.Position).Magnitude or 400
    end

    function RTX.buildFlare(parent, cfg)
        local flare = {cur = 0, ghosts = {}}
        flare.glow = RTX.circle(parent, cfg.glow or 260, UDim2.fromScale(.5, .5), cfg.color, 1)
        new("UIGradient", {Transparency = NumberSequence.new({nk(0, 0), nk(.6, .7), nk(1, 1)}), Rotation = 0}, flare.glow)
        flare.streak = new("Frame", {AnchorPoint = Vector2.new(.5, .5), Size = UDim2.fromOffset(cfg.streakW or 600, cfg.streakH or 3), BackgroundColor3 = cfg.streakColor or cfg.color, BackgroundTransparency = 1}, parent)
        new("UIGradient", {Transparency = NumberSequence.new({nk(0, 1), nk(.5, 0), nk(1, 1)})}, flare.streak)
        for i, g in ipairs(cfg.ghosts or {}) do
            local c = RTX.circle(parent, g.size, UDim2.fromScale(.5, .5), g.color or cfg.color, 1, nil)
            if g.ring then Util.stroke(c, g.ring, g.color or cfg.color, 1) end
            flare.ghosts[i] = {frame = c, ratio = g.ratio, tr = g.tr or .85, ring = g.ring}
        end
        function flare.update(dt, cam, vs, power)
            local sunDir = Lighting:GetSunDirection()
            local camPos = cam.CFrame.Position
            local p3 = cam:WorldToViewportPoint(camPos + sunDir * 900)
            local target = 0
            local sp = Vector2.new(p3.X, p3.Y)
            local center = Vector2.new(vs.X / 2, vs.Y / 2)
            if p3.Z > 0 and RTX.opt.flare then
                rayP.FilterDescendantsInstances = {lp.Character, RTX.folder}
                local hit = workspace:Raycast(camPos, sunDir * 900, rayP)
                if not hit then
                    local dn = (sp - center).Magnitude / (vs.Magnitude * .5)
                    target = math.clamp(1.3 - dn, 0, 1) * power
                end
            end
            flare.cur += (target - flare.cur) * (1 - math.exp(-dt * 6))
            local a = flare.cur
            local show = a > .01
            flare.glow.Visible, flare.streak.Visible = show, show
            for _, g in ipairs(flare.ghosts) do g.frame.Visible = show end
            if not show then return end
            flare.glow.Position = UDim2.fromOffset(sp.X, sp.Y)
            flare.glow.BackgroundTransparency = 1 - a * (cfg.glowA or .55)
            flare.streak.Position = UDim2.fromOffset(sp.X, sp.Y)
            flare.streak.BackgroundTransparency = 1 - a * (cfg.streakA or .9)
            for _, g in ipairs(flare.ghosts) do
                local p = center + (center - sp) * g.ratio
                g.frame.Position = UDim2.fromOffset(p.X, p.Y)
                g.frame.BackgroundTransparency = g.ring and 1 or (1 - (1 - g.tr) * a)
                if g.ring then
                    local st = g.frame:FindFirstChildOfClass("UIStroke")
                    if st then st.Transparency = 1 - (1 - g.tr) * a end
                end
            end
        end
        return flare
    end

    function RTX.neonScan(cam, maxCount, radius)
        local op = OverlapParams.new()
        op.FilterType = Enum.RaycastFilterType.Exclude
        op.FilterDescendantsInstances = {lp.Character, RTX.folder}
        local found = {}
        for _, p in ipairs(workspace:GetPartBoundsInRadius(cam.CFrame.Position, radius, op)) do
            if p.Material == Enum.Material.Neon and p.Transparency < .9 then
                found[#found + 1] = {part = p, d = (p.Position - cam.CFrame.Position).Magnitude}
            end
        end
        table.sort(found, function(a, b) return a.d < b.d end)
        local keep = {}
        for i = 1, math.min(maxCount, #found) do
            local p = found[i].part
            keep[p] = true
            local l = RTX.lights[p]
            if not l then
                l = Instance.new("PointLight")
                l.Name = "AuraRTXGlow"
                l.Shadows = false
                l.Parent = p
                RTX.lights[p] = l
            end
            local s = p.Size
            l.Color = p.Color
            l.Range = math.clamp(math.max(s.X, s.Y, s.Z) * 3.2, 9, 28)
            l.Brightness = 1.5
        end
        for p, l in pairs(RTX.lights) do
            if not keep[p] then
                pcall(function() l:Destroy() end)
                RTX.lights[p] = nil
            end
        end
    end

    function RTX.refreshRefl(cfg)
        RTX.reflToken += 1
        local my = RTX.reflToken
        task.spawn(function()
            for part, orig in pairs(RTX.refl) do
                if part.Parent then part.Reflectance = orig end
            end
            table.clear(RTX.refl)
            if not (cfg and RTX.opt.reflect) then return end
            local n = 0
            for _, d in ipairs(workspace:GetDescendants()) do
                if my ~= RTX.reflToken then return end
                if d:IsA("BasePart") and not d:IsA("Terrain") and cfg.materials[d.Material] and d.Transparency < .95 then
                    local mdl = d:FindFirstAncestorWhichIsA("Model")
                    if not (mdl and mdl:FindFirstChildOfClass("Humanoid")) and not d:IsDescendantOf(RTX.folder or workspace.Terrain) then
                        RTX.refl[d] = d.Reflectance
                        d.Reflectance = math.max(d.Reflectance, cfg.amount * RTX.k)
                        n += 1
                        if n % 300 == 0 then task.wait() end
                        if n > 9000 then return end
                    end
                end
            end
        end)
    end

    RTX.opt.future = not UIS.TouchEnabled
    RTX.opt.shadows, RTX.opt.glow, RTX.opt.grade, RTX.opt.haze, RTX.opt.dof = true, true, true, true, true

    -- extra "RTX quality" layer on top of every mode profile
    function RTX.polish(p, atmoBase)
        local k = math.min(RTX.k, 1.5)
        local q = {}
        for key, v in pairs(p) do q[key] = v end
        q.light, q.bloom, q.cc = merge({}, p.light), merge({}, p.bloom), merge({}, p.cc)
        q.dof, q.atmo = merge({}, p.dof), merge({}, p.atmo)
        if RTX.opt.shadows then
            local cur = q.light.ShadowSoftness or (RTX.snap and RTX.snap.ShadowSoftness) or .2
            q.light.ShadowSoftness = math.clamp(math.max(cur, .26 + .1 * k), 0, 1)
            q.light.EnvironmentSpecularScale = 1
            q.light.EnvironmentDiffuseScale = math.clamp(math.max(q.light.EnvironmentDiffuseScale or 0, .8), 0, 1)
        end
        if RTX.opt.glow then
            q.bloom.Intensity = (q.bloom.Intensity or 0) + .12 * k
            q.bloom.Size = math.max(q.bloom.Size or 24, 30)
            q.bloom.Threshold = math.clamp((q.bloom.Threshold or 1) - .08 * k, .5, 4)
        end
        if RTX.opt.grade then
            q.cc.Contrast = (q.cc.Contrast or 0) + .05 * k
            q.cc.Saturation = (q.cc.Saturation or 0) + .06 * k
        end
        if RTX.opt.haze then
            local base = q.atmo.Haze
            if base == nil then base = atmoBase and atmoBase.Haze or 0 end
            q.atmo.Haze = math.clamp(base + .7 * k, 0, 10)
        end
        if not RTX.opt.dof then
            q.dof.FarIntensity, q.dof.NearIntensity = 0, 0
        end
        return q
    end

    -- optional Future lighting (needs an executor with gethiddenproperty / sethiddenproperty)
    function RTX.setTech(on)
        if not sethiddenproperty then return end
        if on then
            if RTX.techSnap == nil and gethiddenproperty then
                local ok, v = pcall(gethiddenproperty, Lighting, "Technology")
                if ok then RTX.techSnap = v end
            end
            pcall(sethiddenproperty, Lighting, "Technology", Enum.Technology.Future)
        elseif RTX.techSnap ~= nil then
            pcall(sethiddenproperty, Lighting, "Technology", RTX.techSnap)
            RTX.techSnap = nil
        end
    end

    local function applyProfile(dur)
        local m = RTX.modes[RTX.mode]
        if not m then return end
        local p = m.profile(RTX.k)
        local fx = RTX.fx
        local lightBase = {}
        for _, key in ipairs(LIGHT_KEYS) do lightBase[key] = RTX.snap[key] end
        local atmoBase = fx.atmoOwn and DEFAULTS.atmo or fx.atmoSnap
        p = RTX.polish(p, atmoBase)
        tweenTo(Lighting, merge(lightBase, p.light), dur)
        tweenTo(fx.bloom, merge(DEFAULTS.bloom, p.bloom), dur)
        tweenTo(fx.cc, merge(DEFAULTS.cc, p.cc), dur)
        tweenTo(fx.rays, merge(DEFAULTS.rays, p.rays), dur)
        tweenTo(fx.dof, merge(DEFAULTS.dof, p.dof), dur)
        tweenTo(fx.atmo, merge(atmoBase, p.atmo), dur)
        local terrain = workspace:FindFirstChildOfClass("Terrain")
        if terrain and RTX.terrainSnap then tweenTo(terrain, merge(RTX.terrainSnap, p.terrain), dur) end
        RTX.vigTarget = p.vig or .3
        RTX.barsTarget = p.bars or 0
        RTX.clockTarget = p.clock or RTX.clockCur
        RTX.clockAmp, RTX.clockSpeed = p.clockAmp or 0, p.clockSpeed or .05
        RTX.expBase = p.light and p.light.ExposureCompensation or RTX.snap.ExposureCompensation
        RTX.refreshRefl(p.refl)
    end
    RTX.applyProfile = applyProfile

    function RTX.kick(amount, dur)
        local fx = RTX.fx
        if not fx.flash then return end
        fx.flash.Brightness = amount
        tweenTo(fx.flash, {Brightness = 0}, dur)
        if RTX.flashF then
            RTX.flashF.BackgroundTransparency = 1 - amount * .8
            TS:Create(RTX.flashF, TweenInfo.new(dur, EASE.Quad, DIR.Out), {BackgroundTransparency = 1}):Play()
        end
    end

    local function initMode()
        local m = RTX.modes[RTX.mode]
        RTX.ctx = m.init and m.init(RTX.layer) or {}
    end

    local function loop(dt)
        local m = RTX.modes[RTX.mode]
        local cam = workspace.CurrentCamera
        if not (m and cam and RTX.sg) then return end
        local t = os.clock() - RTX.t0
        local ka = 1 - math.exp(-dt * 2.2)
        RTX.vig += (RTX.vigTarget - RTX.vig) * ka
        for _, f in ipairs(RTX.vigs) do f.BackgroundTransparency = 1 - RTX.vig end
        RTX.bars += ((RTX.opt.letterbox and RTX.barsTarget or 0) - RTX.bars) * ka
        RTX.barTop.Size = UDim2.fromScale(1, RTX.bars)
        RTX.barBot.Size = UDim2.fromScale(1, RTX.bars)
        RTX.clockCur += (RTX.clockTarget - RTX.clockCur) * (1 - math.exp(-dt * 1.2))
        Lighting.ClockTime = (RTX.clockCur + math.sin(t * RTX.clockSpeed) * RTX.clockAmp) % 24
        RTX.layer.Visible = RTX.opt.overlay
        if m.update then m.update(RTX.ctx, t, dt, cam, cam.ViewportSize) end
        local fl = RTX.ctx and RTX.ctx.flare
        RTX.adapt += ((fl and fl.cur * .45 * RTX.k or 0) - RTX.adapt) * (1 - math.exp(-dt * 1.6))
        if t > 3 and RTX.expBase then Lighting.ExposureCompensation = RTX.expBase - RTX.adapt end
        if RTX.opt.sway then
            local k = RTX.k * .0011
            cam.CFrame = cam.CFrame * CFrame.Angles(math.sin(t * .71) * k, math.cos(t * .53) * k, math.sin(t * .37) * k * .7)
        end
    end

    function RTX.start(idx)
        if RTX.sg then RTX.sg:Destroy() RTX.sg = nil end
        if RTX.folder then RTX.folder:Destroy() RTX.folder = nil end
        snapshot()
        ensureFx()
        if RTX.opt.future then RTX.setTech(true) end
        buildOverlay()
        RTX.folder = Instance.new("Folder")
        RTX.folder.Name = "AuraRTXFX"
        RTX.folder.Parent = workspace
        RTX.t0 = os.clock()
        RTX.clockCur = Lighting.ClockTime
        RTX.clockTarget = RTX.clockCur
        RTX.mode = idx
        initMode()
        applyProfile(2.4)
        RS:BindToRenderStep("AuraRTXLoop", Enum.RenderPriority.Camera.Value + 3, loop)
    end

    function RTX.switch(idx)
        local old = RTX.modes[RTX.mode]
        if old and old.destroy then pcall(old.destroy, RTX.ctx) end
        for _, c in ipairs(RTX.layer:GetChildren()) do c:Destroy() end
        for _, l in pairs(RTX.lights) do pcall(function() l:Destroy() end) end
        table.clear(RTX.lights)
        RTX.mode = idx
        initMode()
        applyProfile(1.8)
    end

    function RTX.stop()
        if RTX.mode == 0 then return end
        RTX.setTech(false)
        pcall(function() RS:UnbindFromRenderStep("AuraRTXLoop") end)
        local old = RTX.modes[RTX.mode]
        if old and old.destroy then pcall(old.destroy, RTX.ctx) end
        RTX.mode = 0
        RTX.ctx = nil
        RTX.refreshRefl(nil)
        for _, l in pairs(RTX.lights) do pcall(function() l:Destroy() end) end
        table.clear(RTX.lights)
        local fx, snap = RTX.fx, RTX.snap
        local lightBack = {}
        for _, key in ipairs(LIGHT_KEYS) do lightBack[key] = snap[key] end
        lightBack.ClockTime = snap.ClockTime
        tweenTo(Lighting, lightBack, 1.6)
        for _, name in ipairs({"bloom", "cc", "rays", "dof"}) do tweenTo(fx[name], DEFAULTS[name], 1.6) end
        if fx.atmo then tweenTo(fx.atmo, fx.atmoOwn and DEFAULTS.atmo or fx.atmoSnap, 1.6) end
        local terrain = workspace:FindFirstChildOfClass("Terrain")
        if terrain and RTX.terrainSnap then tweenTo(terrain, RTX.terrainSnap, 1.6) end
        RTX.vigTarget, RTX.barsTarget = 0, 0
        local sg, vigs, top, bot = RTX.sg, RTX.vigs, RTX.barTop, RTX.barBot
        TS:Create(RTX.layer, TweenInfo.new(.8), {GroupTransparency = 1}):Play()
        for _, f in ipairs(vigs) do TS:Create(f, TweenInfo.new(1.2), {BackgroundTransparency = 1}):Play() end
        TS:Create(top, TweenInfo.new(1.2, EASE.Quint, DIR.InOut), {Size = UDim2.fromScale(1, 0)}):Play()
        TS:Create(bot, TweenInfo.new(1.2, EASE.Quint, DIR.InOut), {Size = UDim2.fromScale(1, 0)}):Play()
        task.delay(1.8, function()
            if RTX.mode ~= 0 then return end
            if sg then sg:Destroy() end
            RTX.sg = nil
            for name, o in pairs(fx) do
                if typeof(o) == "Instance" and (name ~= "atmo" or fx.atmoOwn) then pcall(function() o:Destroy() end) end
            end
            table.clear(fx)
            if RTX.folder then RTX.folder:Destroy() RTX.folder = nil end
        end)
    end

    function RTX.set(idx)
        if idx == RTX.mode then return end
        if idx == 0 then RTX.stop()
        elseif RTX.mode == 0 then RTX.start(idx)
        else RTX.switch(idx) end
    end

    Util.cleanups = Util.cleanups or {}
    Util.cleanups[#Util.cleanups + 1] = function()
        pcall(function() RS:UnbindFromRenderStep("AuraRTXLoop") end)
        if RTX.mode ~= 0 then
            RTX.setTech(false)
            local old = RTX.modes[RTX.mode]
            if old and old.destroy then pcall(old.destroy, RTX.ctx) end
            RTX.mode = 0
            RTX.refreshRefl(nil)
            if RTX.snap then
                for key, v in pairs(RTX.snap) do pcall(function() Lighting[key] = v end) end
            end
            for _, l in pairs(RTX.lights) do pcall(function() l:Destroy() end) end
            for name, o in pairs(RTX.fx) do
                if typeof(o) == "Instance" and (name ~= "atmo" or RTX.fx.atmoOwn) then pcall(function() o:Destroy() end) end
            end
            if RTX.sg then RTX.sg:Destroy() end
            if RTX.folder then RTX.folder:Destroy() end
        end
    end
end

do
    local Util = __AuraFixUtil
    local RTX = Util.rtx
    local new = Util.new
    local nk, kp = NumberSequenceKeypoint.new, ColorSequenceKeypoint.new
    local MAT = Enum.Material
    local GLOSS = {
        [MAT.Metal] = true, [MAT.Glass] = true, [MAT.Marble] = true, [MAT.Granite] = true, [MAT.Concrete] = true,
        [MAT.SmoothPlastic] = true, [MAT.Foil] = true, [MAT.DiamondPlate] = true, [MAT.CorrodedMetal] = true, [MAT.Ice] = true,
    }
    local M = {}

    function M.profile(k)
        local kc = math.min(k, 1)
        return {
            light = {
                Brightness = 2.4, ExposureCompensation = .12 * k, EnvironmentDiffuseScale = 1, EnvironmentSpecularScale = 1,
                ShadowSoftness = .18, Ambient = Color3.fromRGB(70, 76, 92), OutdoorAmbient = Color3.fromRGB(104, 112, 130),
                ColorShift_Top = Color3.fromRGB(255, 232, 205), ColorShift_Bottom = Color3.fromRGB(22, 34, 48),
                GeographicLatitude = 41,
            },
            bloom = {Intensity = .55 * k, Size = 36, Threshold = .85},
            cc = {Brightness = .02 * k, Contrast = .16 * k, Saturation = .1 * k, TintColor = WHITE:Lerp(Color3.fromRGB(255, 238, 222), .6 * kc)},
            rays = {Intensity = .14 * k, Spread = .55},
            dof = {FarIntensity = .22 * k, NearIntensity = .05 * k, FocusDistance = 40, InFocusRadius = 28},
            atmo = {Density = .26, Offset = .2, Color = Color3.fromRGB(206, 214, 230), Decay = Color3.fromRGB(110, 120, 140), Glare = .18 * k, Haze = 1.2},
            terrain = {WaterReflectance = 1, WaterTransparency = .72},
            vig = math.clamp(.42 * k, 0, .75),
            bars = .105,
            clock = 15.2, clockAmp = .15, clockSpeed = .02,
            refl = {materials = GLOSS, amount = .14},
        }
    end

    function M.init(layer)
        local ctx = {extra = {}, focus = 40, grain = {}, motes = {}, grainT = 0}

        local leak = new("Frame", {BackgroundColor3 = Color3.fromRGB(255, 150, 70), BackgroundTransparency = .86, Size = UDim2.fromScale(.55, .6)}, layer)
        new("UIGradient", {Rotation = 45, Transparency = NumberSequence.new({nk(0, 0), nk(.55, .75), nk(1, 1)})}, leak)
        TS:Create(leak, TweenInfo.new(6, EASE.Sine, DIR.InOut, -1, true), {BackgroundTransparency = .93}):Play()
        local leak2 = new("Frame", {AnchorPoint = Vector2.new(1, 1), Position = UDim2.fromScale(1, 1), BackgroundColor3 = Color3.fromRGB(70, 140, 255), BackgroundTransparency = .92, Size = UDim2.fromScale(.45, .5)}, layer)
        new("UIGradient", {Rotation = 225, Transparency = NumberSequence.new({nk(0, 0), nk(.6, .8), nk(1, 1)})}, leak2)
        TS:Create(leak2, TweenInfo.new(8, EASE.Sine, DIR.InOut, -1, true), {BackgroundTransparency = .96}):Play()

        for i = 1, 22 do
            local size = math.random(3, 9)
            local c = RTX.circle(layer, size, UDim2.fromScale(math.random(), math.random()), Color3.fromRGB(255, 240, 215), .86, nil)
            local d = math.random(14, 28)
            TS:Create(c, TweenInfo.new(d, EASE.Sine, DIR.InOut, -1, true), {Position = UDim2.fromScale(math.random(), math.random())}):Play()
            task.delay(math.random() * 3, function()
                if c.Parent then TS:Create(c, TweenInfo.new(2 + math.random() * 3, EASE.Sine, DIR.InOut, -1, true), {BackgroundTransparency = .97}):Play() end
            end)
            ctx.motes[i] = c
        end

        for i = 1, 3 do
            local dirt = RTX.circle(layer, math.random(110, 220), UDim2.fromScale(i == 1 and .08 or (i == 2 and .93 or .5), i == 3 and .96 or (i == 1 and .9 or .12)), Color3.fromRGB(255, 255, 255), .985, nil)
            new("UIGradient", {Transparency = NumberSequence.new({nk(0, .2), nk(1, 1)})}, dirt)
        end

        RTX.chroma(layer, .07)
        for i = 1, 70 do
            local g = new("Frame", {Size = UDim2.fromOffset(1, 1), BackgroundColor3 = WHITE, BackgroundTransparency = .9, Position = UDim2.fromScale(math.random(), math.random())}, layer)
            ctx.grain[i] = g
        end

        ctx.flare = RTX.buildFlare(layer, {
            color = Color3.fromRGB(255, 214, 160), glow = 320, glowA = .38,
            streakW = 1000, streakH = 4, streakColor = Color3.fromRGB(120, 170, 255), streakA = .8,
            ghosts = {
                {ratio = .35, size = 38, tr = .9, color = Color3.fromRGB(255, 190, 120)},
                {ratio = .75, size = 96, tr = .88, color = Color3.fromRGB(150, 200, 255), ring = 2},
                {ratio = 1.25, size = 28, tr = .84, color = Color3.fromRGB(255, 160, 200)},
                {ratio = -.3, size = 64, tr = .9, color = Color3.fromRGB(190, 255, 220), ring = 1.5},
                {ratio = 1.7, size = 130, tr = .92, color = Color3.fromRGB(255, 220, 170), ring = 1.2},
            },
        })

        local sg = RTX.sg
        ctx.rec = new("TextLabel", {Position = UDim2.fromOffset(16, 8), Size = UDim2.fromOffset(90, 18), BackgroundTransparency = 1, Font = Enum.Font.GothamBold, TextSize = 12, TextColor3 = Color3.fromRGB(255, 80, 90), TextXAlignment = Enum.TextXAlignment.Left, Text = "● REC", ZIndex = 3}, sg)
        ctx.tc = new("TextLabel", {AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -16, 0, 8), Size = UDim2.fromOffset(140, 18), BackgroundTransparency = 1, Font = Enum.Font.Code, TextSize = 12, TextColor3 = Color3.fromRGB(235, 235, 245), TextTransparency = .25, TextXAlignment = Enum.TextXAlignment.Right, Text = "00:00:00:00", ZIndex = 3}, sg)
        ctx.lens = new("TextLabel", {AnchorPoint = Vector2.new(0, 1), Position = UDim2.new(0, 16, 1, -8), Size = UDim2.fromOffset(220, 18), BackgroundTransparency = 1, Font = Enum.Font.Code, TextSize = 11, TextColor3 = Color3.fromRGB(235, 235, 245), TextTransparency = .35, TextXAlignment = Enum.TextXAlignment.Left, Text = "", ZIndex = 3}, sg)
        ctx.extra = {ctx.rec, ctx.tc, ctx.lens}

        ctx.af = new("Frame", {AnchorPoint = Vector2.new(.5, .5), Position = UDim2.fromScale(.5, .5), Size = UDim2.fromOffset(46, 46), BackgroundTransparency = 1}, layer)
        for i = 1, 4 do
            local ax, ay = (i == 2 or i == 4) and 1 or 0, i >= 3 and 1 or 0
            for _, horiz in ipairs({true, false}) do
                new("Frame", {AnchorPoint = Vector2.new(ax, ay), Position = UDim2.fromScale(ax, ay), Size = horiz and UDim2.fromOffset(10, 1) or UDim2.fromOffset(1, 10), BackgroundColor3 = WHITE, BackgroundTransparency = .35}, ctx.af)
            end
        end
        ctx.afScale = new("UIScale", {}, ctx.af)
        ctx.afLabel = new("TextLabel", {AnchorPoint = Vector2.new(.5, 0), Position = UDim2.new(.5, 0, 1, 6), Size = UDim2.fromOffset(80, 12), BackgroundTransparency = 1, Font = Enum.Font.Code, TextSize = 10, TextColor3 = WHITE, TextTransparency = .3, Text = ""}, ctx.af)
        return ctx
    end

    function M.update(ctx, t, dt, cam, vs)
        local target = RTX.focusDistance(cam)
        local old = ctx.focus
        ctx.focus += (target - ctx.focus) * (1 - math.exp(-dt * 3.2))
        local dof = RTX.fx.dof
        if dof then
            dof.FocusDistance = ctx.focus
            dof.InFocusRadius = math.clamp(ctx.focus * .18 + 6, 8, 70)
        end
        local hunting = math.abs(ctx.focus - old) / math.max(dt, 1e-3) > 6
        ctx.afScale.Scale += ((hunting and 1.25 or 1) - ctx.afScale.Scale) * (1 - math.exp(-dt * 10))
        ctx.afLabel.Text = string.format("%.1f m", ctx.focus * .28)

        ctx.flare.update(dt, cam, vs, RTX.k)
        local bloom = RTX.fx.bloom
        if bloom and t > 3 then
            bloom.Intensity = (.55 + ctx.flare.cur * .35 + math.sin(t * .8) * .03) * RTX.k
            bloom.Threshold = .85 - ctx.flare.cur * .1
        end

        ctx.grainT -= dt
        if ctx.grainT <= 0 then
            ctx.grainT = 1 / 14
            for _, g in ipairs(ctx.grain) do
                g.Position = UDim2.fromScale(math.random(), math.random())
                g.BackgroundTransparency = .84 + math.random() * .14
                g.Size = UDim2.fromOffset(math.random(1, 2), math.random(1, 2))
            end
        end

        ctx.rec.Visible = (t % 1.4) < .9
        local total = math.floor(t * 24)
        ctx.tc.Text = string.format("%02d:%02d:%02d:%02d", total // 86400, total // 1440 % 60, total // 24 % 60, total % 24)
        local fov = cam.FieldOfView
        ctx.lens.Text = string.format("%.0fmm  f/%.1f  ISO %d", 24 / math.tan(math.rad(fov / 2)) * .42, 1.8 + (ctx.focus / 400) * 3, 100 + math.floor(RTX.k * 100))
    end

    function M.destroy(ctx)
        if not ctx then return end
        for _, o in ipairs(ctx.extra or {}) do pcall(function() o:Destroy() end) end
    end

    RTX.modes[1] = M
end

do
    local Util = __AuraFixUtil
    local RTX = Util.rtx
    local new = Util.new
    local nk, kp = NumberSequenceKeypoint.new, ColorSequenceKeypoint.new
    local MAT = Enum.Material
    local WET = {
        [MAT.Asphalt] = true, [MAT.Pavement] = true, [MAT.Concrete] = true, [MAT.Cobblestone] = true, [MAT.Slate] = true,
        [MAT.Brick] = true, [MAT.Granite] = true, [MAT.Pebble] = true, [MAT.Basalt] = true, [MAT.Metal] = true,
        [MAT.Glass] = true, [MAT.SmoothPlastic] = true, [MAT.DiamondPlate] = true, [MAT.Marble] = true,
    }
    local M = {}

    function M.profile(k)
        local kc = math.min(k, 1)
        return {
            light = {
                Brightness = .9, ExposureCompensation = .35 * k, EnvironmentDiffuseScale = .6, EnvironmentSpecularScale = 1,
                ShadowSoftness = .3, Ambient = Color3.fromRGB(26, 24, 52), OutdoorAmbient = Color3.fromRGB(44, 40, 86),
                ColorShift_Top = Color3.fromRGB(120, 70, 200), ColorShift_Bottom = Color3.fromRGB(20, 60, 90),
                GeographicLatitude = 35,
            },
            bloom = {Intensity = 1.05 * k, Size = 44, Threshold = .7},
            cc = {Brightness = -.02, Contrast = .25 * k, Saturation = .35 * k, TintColor = WHITE:Lerp(Color3.fromRGB(215, 190, 255), .7 * kc)},
            rays = {Intensity = .05, Spread = .4},
            dof = {FarIntensity = .12 * k, NearIntensity = 0, FocusDistance = 60, InFocusRadius = 40},
            atmo = {Density = .42, Offset = .1, Color = Color3.fromRGB(120, 80, 200), Decay = Color3.fromRGB(40, 20, 90), Glare = .6, Haze = 2.4},
            terrain = {WaterReflectance = 1, WaterTransparency = .5, WaterWaveSize = .4},
            vig = math.clamp(.5 * k, 0, .8),
            bars = 0,
            clock = .6, clockAmp = 0, clockSpeed = .02,
            refl = {materials = WET, amount = .3},
        }
    end

    local function edgeStrip(layer, left, color)
        local f = new("Frame", {AnchorPoint = Vector2.new(left and 0 or 1, 0), Position = UDim2.fromScale(left and 0 or 1, 0), Size = UDim2.fromScale(.1, 1), BackgroundColor3 = color, BackgroundTransparency = .8}, layer)
        new("UIGradient", {Rotation = left and 0 or 180, Transparency = NumberSequence.new({nk(0, 0), nk(.6, .86), nk(1, 1)})}, f)
        TS:Create(f, TweenInfo.new(3.2 + math.random(), EASE.Sine, DIR.InOut, -1, true), {BackgroundTransparency = .9}):Play()
        return f
    end

    function M.init(layer)
        local ctx = {scanT = 0, dropT = 0, nextFlash = 6 + math.random() * 6, sweep = nil, rain = {}}
        edgeStrip(layer, true, Color3.fromRGB(255, 40, 140))
        edgeStrip(layer, false, Color3.fromRGB(30, 220, 255))

        local top = new("Frame", {BackgroundColor3 = Color3.fromRGB(150, 60, 255), BackgroundTransparency = .9, Size = UDim2.fromScale(1, .4)}, layer)
        new("UIGradient", {Rotation = 90, Transparency = NumberSequence.new({nk(0, 0), nk(1, 1)})}, top)

        for i = 1, 40 do
            local y = i / 40
            new("Frame", {Position = UDim2.fromScale(0, y), Size = UDim2.new(1, 0, 0, 1), BackgroundColor3 = Color3.new(0, 0, 0), BackgroundTransparency = .93}, layer)
        end
        ctx.streaks = {}
        for i = 1, 9 do
            local col = i % 2 == 0 and Color3.fromRGB(255, 50, 150) or Color3.fromRGB(40, 220, 255)
            local f = new("Frame", {AnchorPoint = Vector2.new(.5, 1), Position = UDim2.fromScale(i / 10, 1), Size = UDim2.fromOffset(math.random(4, 14), math.random(70, 150)), BackgroundColor3 = col, BackgroundTransparency = .85}, layer)
            new("UIGradient", {Rotation = 90, Transparency = NumberSequence.new({nk(0, 1), nk(1, 0)})}, f)
            TS:Create(f, TweenInfo.new(1.2 + math.random() * 2, EASE.Sine, DIR.InOut, -1, true), {BackgroundTransparency = .95}):Play()
            ctx.streaks[i] = {f = f, base = i / 10, ph = math.random() * 6}
        end
        for i = 1, 3 do
            local mist = new("Frame", {AnchorPoint = Vector2.new(.5, .5), Position = UDim2.fromScale(-.2, .5 + i * .1), Size = UDim2.fromScale(.7, .18), BackgroundColor3 = Color3.fromRGB(120, 70, 220), BackgroundTransparency = .93}, layer)
            new("UIGradient", {Transparency = NumberSequence.new({nk(0, 1), nk(.5, 0), nk(1, 1)})}, mist)
            TS:Create(mist, TweenInfo.new(34 + i * 9, EASE.Sine, DIR.InOut, -1, true), {Position = UDim2.fromScale(1.2, .5 + i * .1)}):Play()
        end
        ctx.flickT = 0
        ctx.sweep = new("Frame", {Size = UDim2.new(1, 0, 0, 90), Position = UDim2.new(0, 0, 0, -100), BackgroundColor3 = Color3.fromRGB(190, 160, 255), BackgroundTransparency = .96}, layer)
        new("UIGradient", {Rotation = 90, Transparency = NumberSequence.new({nk(0, 1), nk(.5, 0), nk(1, 1)})}, ctx.sweep)
        TS:Create(ctx.sweep, TweenInfo.new(5, EASE.Linear, DIR.In, -1), {Position = UDim2.new(0, 0, 1, 10)}):Play()

        for layerIdx = 1, 2 do
            local far = layerIdx == 1
            for i = 1, far and 36 or 22 do
                local len = far and math.random(10, 18) or math.random(20, 36)
                local drop = new("Frame", {AnchorPoint = Vector2.new(.5, .5), Rotation = 12, Size = UDim2.fromOffset(far and 1 or 2, len), BackgroundColor3 = Color3.fromRGB(190, 210, 255), BackgroundTransparency = far and .82 or .64, Position = UDim2.fromScale(math.random() * 1.1, -.08)}, layer)
                local x0 = math.random() * 1.1
                local dur = far and (.7 + math.random() * .35) or (.42 + math.random() * .22)
                task.delay(math.random() * dur, function()
                    if not drop.Parent then return end
                    drop.Position = UDim2.fromScale(x0, -.08)
                    TS:Create(drop, TweenInfo.new(dur, EASE.Linear, DIR.In, -1), {Position = UDim2.fromScale(x0 - .18, 1.08)}):Play()
                end)
                ctx.rain[#ctx.rain + 1] = drop
            end
        end
        return ctx
    end

    local function lensDrop(layer)
        local size = math.random(10, 26)
        local x, y = math.random(), math.random() * .8
        local d = RTX.circle(layer, size, UDim2.fromScale(x, y), Color3.fromRGB(200, 220, 255), .93, .75)
        d.Size = UDim2.fromOffset(2, 2)
        TS:Create(d, TweenInfo.new(.35, EASE.Back, DIR.Out), {Size = UDim2.fromOffset(size, size)}):Play()
        task.delay(.5, function()
            if not d.Parent then return end
            TS:Create(d, TweenInfo.new(2.2 + math.random(), EASE.Quad, DIR.In), {Position = UDim2.fromScale(x + (math.random() - .5) * .02, y + .12 + math.random() * .1), BackgroundTransparency = 1, Size = UDim2.fromOffset(size * .6, size * 1.4)}):Play()
            local st = d:FindFirstChildOfClass("UIStroke")
            if st then TS:Create(st, TweenInfo.new(2.4), {Transparency = 1}):Play() end
            task.delay(3.6, function() if d.Parent then d:Destroy() end end)
        end)
    end

    function M.update(ctx, t, dt, cam, vs)
        ctx.scanT -= dt
        if ctx.scanT <= 0 then
            ctx.scanT = 2.5
            RTX.neonScan(cam, 26, 160)
        end

        ctx.dropT -= dt
        if ctx.dropT <= 0 and RTX.opt.overlay then
            ctx.dropT = .6 + math.random() * 1.1
            lensDrop(RTX.layer)
        end

        if t > ctx.nextFlash then
            ctx.nextFlash = t + 8 + math.random() * 11
            RTX.kick(.45, .5)
            task.delay(.14, function() if RTX.mode == 2 then RTX.kick(.3, .9) end end)
        end

        for _, s in ipairs(ctx.streaks) do
            s.f.Position = UDim2.fromScale(s.base + math.sin(t * .6 + s.ph) * .015, 1)
        end
        ctx.flickT -= dt
        if ctx.flickT <= 0 then
            ctx.flickT = .1
            for _, l in pairs(RTX.lights) do
                if math.random() < .05 then l.Brightness = .3 + math.random() * .6
                else l.Brightness += (1.5 - l.Brightness) * .35 end
            end
        end
        local bloom = RTX.fx.bloom
        if bloom and t > 3 then
            bloom.Intensity = (1.05 + math.sin(t * 1.3) * .12 + math.sin(t * 3.7) * .04) * RTX.k
        end
        local cc = RTX.fx.cc
        if cc and t > 3 then
            local k = (math.sin(t * .25) + 1) / 2
            cc.TintColor = WHITE:Lerp(Color3.fromRGB(215, 190, 255):Lerp(Color3.fromRGB(190, 230, 255), k), .7 * math.min(RTX.k, 1))
        end
    end

    function M.destroy(ctx)
        for p, l in pairs(RTX.lights) do
            pcall(function() l:Destroy() end)
            RTX.lights[p] = nil
        end
    end

    RTX.modes[2] = M
end

do
    local Util = __AuraFixUtil
    local RTX = Util.rtx
    local new = Util.new
    local nk, kp = NumberSequenceKeypoint.new, ColorSequenceKeypoint.new
    local MAT = Enum.Material
    local SHINY = {
        [MAT.Glass] = true, [MAT.Metal] = true, [MAT.Marble] = true, [MAT.Granite] = true, [MAT.Ice] = true,
        [MAT.SmoothPlastic] = true, [MAT.Foil] = true, [MAT.DiamondPlate] = true, [MAT.Concrete] = true, [MAT.Wood] = true,
    }
    local WARM = {
        Color3.fromRGB(255, 214, 150), Color3.fromRGB(255, 190, 120), Color3.fromRGB(255, 232, 190), Color3.fromRGB(255, 170, 130),
    }
    local M = {}

    function M.profile(k)
        local kc = math.min(k, 1)
        return {
            light = {
                Brightness = 3.2, ExposureCompensation = .3 * k, EnvironmentDiffuseScale = 1, EnvironmentSpecularScale = 1,
                ShadowSoftness = .08, Ambient = Color3.fromRGB(110, 92, 84), OutdoorAmbient = Color3.fromRGB(150, 124, 110),
                ColorShift_Top = Color3.fromRGB(255, 190, 120), ColorShift_Bottom = Color3.fromRGB(70, 50, 80),
                GeographicLatitude = 28,
            },
            bloom = {Intensity = .75 * k, Size = 52, Threshold = .8},
            cc = {Brightness = .03, Contrast = .12 * k, Saturation = .28 * k, TintColor = WHITE:Lerp(Color3.fromRGB(255, 214, 170), .75 * kc)},
            rays = {Intensity = .42 * k, Spread = .95},
            dof = {FarIntensity = .1 * k, NearIntensity = 0, FocusDistance = 70, InFocusRadius = 45},
            atmo = {Density = .38, Offset = .35, Color = Color3.fromRGB(255, 196, 150), Decay = Color3.fromRGB(230, 130, 110), Glare = .9, Haze = 2},
            terrain = {WaterReflectance = 1, WaterTransparency = .6},
            vig = math.clamp(.36 * k, 0, .7),
            bars = 0,
            clock = 17.45, clockAmp = .35, clockSpeed = .035,
            refl = {materials = SHINY, amount = .16},
        }
    end

    function M.init(layer)
        local ctx = {shafts = {}, bokeh = {}, angle = 0}

        local terrain = workspace:FindFirstChildOfClass("Terrain")
        if terrain then
            local existing = terrain:FindFirstChildOfClass("Clouds")
            if existing then
                ctx.clouds, ctx.cloudOwn = existing, false
                ctx.cloudSnap = {Cover = existing.Cover, Density = existing.Density, Color = existing.Color}
            else
                ctx.clouds = Instance.new("Clouds")
                ctx.clouds.Name = "AuraRTXClouds"
                ctx.clouds.Cover, ctx.clouds.Density = 0, 0
                ctx.clouds.Parent = terrain
                ctx.cloudOwn = true
            end
            RTX.tweenTo(ctx.clouds, {Cover = .55, Density = .6, Color = Color3.fromRGB(255, 205, 170)}, 3)
        end

        local topWash = new("Frame", {BackgroundColor3 = Color3.fromRGB(255, 190, 110), BackgroundTransparency = .9, Size = UDim2.fromScale(1, .55)}, layer)
        new("UIGradient", {Rotation = 90, Transparency = NumberSequence.new({nk(0, 0), nk(1, 1)})}, topWash)
        local botWash = new("Frame", {AnchorPoint = Vector2.new(0, 1), Position = UDim2.fromScale(0, 1), BackgroundColor3 = Color3.fromRGB(150, 70, 140), BackgroundTransparency = .92, Size = UDim2.fromScale(1, .4)}, layer)
        new("UIGradient", {Rotation = 270, Transparency = NumberSequence.new({nk(0, 0), nk(1, 1)})}, botWash)
        TS:Create(topWash, TweenInfo.new(7, EASE.Sine, DIR.InOut, -1, true), {BackgroundTransparency = .94}):Play()

        for i = 1, 5 do
            local s = new("Frame", {AnchorPoint = Vector2.new(.5, 0), Size = UDim2.fromOffset(math.random(40, 120), 1400), BackgroundColor3 = Color3.fromRGB(255, 226, 170), BackgroundTransparency = 1}, layer)
            new("UIGradient", {Rotation = 90, Transparency = NumberSequence.new({nk(0, 0), nk(.45, .55), nk(1, 1)})}, s)
            ctx.shafts[i] = {frame = s, off = (i - 3) * 9, sway = math.random() * 6, spd = .3 + math.random() * .4}
        end

        for i = 1, 16 do
            local size = math.random(20, 90)
            local c = WARM[math.random(1, #WARM)]
            local b = RTX.circle(layer, size, UDim2.fromScale(math.random(), math.random()), c, .94, .86)
            TS:Create(b, TweenInfo.new(12 + math.random() * 14, EASE.Sine, DIR.InOut, -1, true), {Position = UDim2.fromScale(math.random(), math.random())}):Play()
            TS:Create(b, TweenInfo.new(2.5 + math.random() * 3, EASE.Sine, DIR.InOut, -1, true), {BackgroundTransparency = .985}):Play()
            ctx.bokeh[i] = b
        end

        for i = 1, 32 do
            local size = math.random(2, 5)
            local m = RTX.circle(layer, size, UDim2.fromScale(math.random(), 1.05), Color3.fromRGB(255, 230, 190), .72, nil)
            local d = 10 + math.random() * 14
            task.delay(math.random() * d, function()
                if not m.Parent then return end
                TS:Create(m, TweenInfo.new(d, EASE.Linear, DIR.In, -1), {Position = UDim2.fromScale(math.random(), -.05)}):Play()
                TS:Create(m, TweenInfo.new(d / 4, EASE.Sine, DIR.InOut, -1, true), {BackgroundTransparency = .95}):Play()
            end)
        end

        RTX.chroma(layer, .05)
        ctx.glintT = 0
        for i = 1, 3 do
            local sh = new("Frame", {AnchorPoint = Vector2.new(.5, .5), Position = UDim2.fromScale(-.3, .1 + i * .08), Size = UDim2.fromScale(.6, .3), BackgroundColor3 = Color3.new(0, 0, 0), BackgroundTransparency = .95}, layer)
            Util.round(sh, 200)
            new("UIGradient", {Transparency = NumberSequence.new({nk(0, 1), nk(.5, 0), nk(1, 1)})}, sh)
            TS:Create(sh, TweenInfo.new(26 + i * 8, EASE.Sine, DIR.InOut, -1, true), {Position = UDim2.fromScale(1.3, .1 + i * .08)}):Play()
        end
        ctx.flare = RTX.buildFlare(layer, {
            color = Color3.fromRGB(255, 200, 130), glow = 420, glowA = .5,
            streakW = 1300, streakH = 5, streakColor = Color3.fromRGB(255, 170, 90), streakA = .85,
            ghosts = {
                {ratio = .3, size = 54, tr = .88, color = Color3.fromRGB(255, 190, 110)},
                {ratio = .62, size = 120, tr = .9, color = Color3.fromRGB(255, 150, 120), ring = 2.4},
                {ratio = 1.05, size = 34, tr = .84, color = Color3.fromRGB(255, 240, 190)},
                {ratio = 1.4, size = 160, tr = .93, color = Color3.fromRGB(255, 210, 150), ring = 1.5},
                {ratio = -.25, size = 70, tr = .9, color = Color3.fromRGB(255, 120, 100), ring = 1.8},
            },
        })
        return ctx
    end

    function M.update(ctx, t, dt, cam, vs)
        ctx.flare.update(dt, cam, vs, RTX.k)
        local p3 = cam:WorldToViewportPoint(cam.CFrame.Position + Lighting:GetSunDirection() * 900)
        local center = Vector2.new(vs.X / 2, vs.Y / 2)
        local sp = Vector2.new(p3.X, p3.Y)
        local toCenter = center - sp
        local target = math.deg(math.atan2(toCenter.Y, toCenter.X)) - 90
        local diff = (target - ctx.angle + 540) % 360 - 180
        ctx.angle += diff * (1 - math.exp(-dt * 4))
        local power = ctx.flare.cur
        for i, s in ipairs(ctx.shafts) do
            local f = s.frame
            f.Visible = power > .02
            if f.Visible then
                f.Position = UDim2.fromOffset(sp.X + s.off, sp.Y)
                f.Rotation = ctx.angle + math.sin(t * s.spd + s.sway) * 5 + (i - 3) * 4
                f.BackgroundTransparency = 1 - power * (.1 + .05 * math.sin(t * .8 + i)) * RTX.k
            end
        end
        ctx.glintT -= dt
        if ctx.glintT <= 0 and RTX.opt.overlay then
            ctx.glintT = .3 + math.random() * .4
            local g = new("Frame", {AnchorPoint = Vector2.new(.5, .5), Position = UDim2.fromScale(math.random(), math.random() * .8), Size = UDim2.fromOffset(4, 4), BackgroundTransparency = 1}, RTX.layer)
            local a = new("Frame", {AnchorPoint = Vector2.new(.5, .5), Position = UDim2.fromScale(.5, .5), Size = UDim2.new(1, 0, 0, 1), BackgroundColor3 = Color3.fromRGB(255, 244, 214)}, g)
            local b = new("Frame", {AnchorPoint = Vector2.new(.5, .5), Position = UDim2.fromScale(.5, .5), Size = UDim2.new(0, 1, 1, 0), BackgroundColor3 = Color3.fromRGB(255, 244, 214)}, g)
            TS:Create(g, TweenInfo.new(.9, EASE.Quint, DIR.Out), {Size = UDim2.fromOffset(26, 26), Rotation = 45}):Play()
            TS:Create(a, TweenInfo.new(.9, EASE.Sine), {BackgroundTransparency = 1}):Play()
            TS:Create(b, TweenInfo.new(.9, EASE.Sine), {BackgroundTransparency = 1}):Play()
            task.delay(1, function() if g.Parent then g:Destroy() end end)
        end
        local cc = RTX.fx.cc
        if cc and t > 3 then
            local ph = (math.sin(t * .12) + 1) / 2
            cc.TintColor = WHITE:Lerp(Color3.fromRGB(255, 214, 170):Lerp(Color3.fromRGB(255, 170, 170), ph), .75 * math.min(RTX.k, 1))
        end
        local rays = RTX.fx.rays
        if rays and t > 3 then
            rays.Intensity = (.42 + math.sin(t * .6) * .06) * RTX.k
        end
        local atmo = RTX.fx.atmo
        if atmo and t > 3 then
            atmo.Glare = .9 + math.sin(t * .45) * .25
        end
    end

    function M.destroy(ctx)
        if not ctx or not ctx.clouds then return end
        if ctx.cloudOwn then
            local c = ctx.clouds
            RTX.tweenTo(c, {Cover = 0, Density = 0}, 1.5)
            task.delay(1.7, function() pcall(function() c:Destroy() end) end)
        else
            RTX.tweenTo(ctx.clouds, ctx.cloudSnap, 1.5)
        end
    end

    RTX.modes[3] = M
end

do
    local Util = __AuraFixUtil
    local RTX, FLY, AIM, AM = Util.rtx, Util.fly, Util.aim, Util.auraMe
    local function fmtPct(v) return string.format("%d%%", v) end

    local pr = Util.page("RTX")
    Util.section(pr, "RTX РЕЖИМЫ")
    Util.rtxSeg = Util.segment(pr, "Режим RTX", {"Выкл", "Кино", "Неон", "Закат"}, function(i)
        RTX.set(i - 1)
        if i > 1 then
            local names = {"Кино RTX", "Неон RTX", "Закат RTX"}
            Util.toast(T("Активен эффект: ") .. T(names[i - 1]), C.good)
        else
            Util.toast("RTX выключен", C.warn)
        end
    end, 1)
    Util.slider(pr, "Сила RTX", 20, 150, 100, fmtPct, function(v)
        RTX.k = v / 100
        if RTX.mode ~= 0 then RTX.applyProfile(.5) end
    end, 5, "rtxK", true)
    Util.section(pr, "ДЕТАЛИ КАРТИНКИ")
    Util.toggle(pr, "Кинолента (чёрные полосы)", true, function(v) RTX.opt.letterbox = v end, "rtxBars")
    Util.toggle(pr, "Блики от солнца", true, function(v) RTX.opt.flare = v end, "rtxFlare")
    Util.toggle(pr, "Покачивание камеры", true, function(v) RTX.opt.sway = v end, "rtxSway")
    Util.toggle(pr, "Оверлей эффектов", true, function(v) RTX.opt.overlay = v end, "rtxOverlay")
    Util.toggle(pr, "Отражения материалов", true, function(v)
        RTX.opt.reflect = v
        if RTX.mode ~= 0 then RTX.applyProfile(.1) end
    end, "rtxRefl")
    Util.section(pr, "КАЧЕСТВО КАРТИНКИ")
    local function rtxOpt(key)
        return function(v)
            RTX.opt[key] = v
            if RTX.mode ~= 0 then RTX.applyProfile(.8) end
        end
    end
    Util.toggle(pr, "Future-освещение (ПК)", not UIS.TouchEnabled, function(v)
        RTX.opt.future = v
        if RTX.mode ~= 0 then RTX.setTech(v) end
    end, "rtxFuture")
    Util.toggle(pr, "Мягкие тени и небо", true, rtxOpt("shadows"), "rtxShadows")
    Util.toggle(pr, "Свечение (Bloom)", true, rtxOpt("glow"), "rtxGlow")
    Util.toggle(pr, "Цветокоррекция", true, rtxOpt("grade"), "rtxGrade")
    Util.toggle(pr, "Объёмная дымка", true, rtxOpt("haze"), "rtxHaze")
    Util.toggle(pr, "Глубина резкости", true, rtxOpt("dof"), "rtxDof")
    Util.section(pr, "О РЕЖИМАХ")
    local info = Util.card(pr, 74)
    Util.lbl(info, "Кино: автофокус, плёночное зерно, анаморфные блики.", 11, C.sub, {Position = UDim2.fromOffset(10, 6), Size = UDim2.new(1, -20, 0, 20)})
    Util.lbl(info, "Неон: ночь, дождь, мокрые отражения, молнии.", 11, C.sub, {Position = UDim2.fromOffset(10, 28), Size = UDim2.new(1, -20, 0, 20)})
    Util.lbl(info, "Закат: золотой час, лучи, облака, боке.", 11, C.sub, {Position = UDim2.fromOffset(10, 50), Size = UDim2.new(1, -20, 0, 20)})

    local NC = Util.noclip
    local int = function(v) return string.format("%d", v) end
    local modeOpts = {"Аккуратный", "Плавный", "Обычный"}
    local hitOpts = {"Голова", "Тело", "Рука", "Ноги", "Рандом"}

    -- ================= ИГРОК =================
    local pp = Util.page("Игрок")
    Util.section(pp, "БЫСТРЫЙ ДОСТУП")
    local chipCard = Util.card(pp, 46)
    local chipDefs = {
        {"Полёт", function() return FLY.on end, function() Util.flyToggle.Set(not FLY.on) end},
        {"Noclip", function() return NC.on end, function() Util.noclipToggle.Set(not NC.on) end},
        {"Aimbot", function() return AIM.on end, function() Util.aimToggle.Set(not AIM.on) end},
        {"Assist", function() return AIM.assist end, function() Util.assistToggle.Set(not AIM.assist) end},
        {"Aura", function() return AM.on end, function() Util.auraToggle.Set(not AM.on) end},
    }
    local chips = {}
    for i, d in ipairs(chipDefs) do
        local b = Util.new("TextButton", {Font = Enum.Font.GothamBold, TextSize = 11, TextColor3 = C.text, AutoButtonColor = false, BackgroundColor3 = C.card2, Position = UDim2.new((i - 1) / #chipDefs, 3, 0, 6), Size = UDim2.new(1 / #chipDefs, -6, 1, -12)}, chipCard)
        bind(b, d[1])
        Util.round(b, 8)
        local st = Util.stroke(b, 1.2, accent, .6)
        Util.acc(st, "Color")
        Util.press(b)
        cn(b.Activated, function() d[3]() end)
        chips[i] = {b = b, get = d[2], on = false}
    end
    local chipAcc = 0
    cn(RS.Heartbeat, function(dt)
        chipAcc += dt
        if chipAcc < .12 then return end
        chipAcc = 0
        for _, it in ipairs(chips) do
            local now = it.get() and true or false
            if now ~= it.on then
                it.on = now
                tw(it.b, {BackgroundColor3 = now and accent or C.card2, TextColor3 = now and WHITE or C.text}, .25)
            elseif now then
                it.b.BackgroundColor3 = accent
            end
        end
    end)

    Util.section(pp, "ПОЛЁТ")
    Util.flyToggle = Util.toggle(pp, "Полёт", false, function(v) Util.flySet(v) end)
    Util.slider(pp, "Скорость полёта", 10, 300, 60, int, function(v) FLY.speed = v end, 1, "flySpeed")
    Util.slider(pp, "Плавность разгона", 1, 20, 8, int, function(v) FLY.smooth = v end, 1, "flySmooth")
    Util.slider(pp, "Скорость вверх/вниз", 20, 150, 80, fmtPct, function(v) FLY.vmul = v / 100 end, 5, "flyVert")
    Util.toggle(pp, "Наклон тела в полёте", true, function(v) FLY.tiltOn = v end, "flyTilt")
    Util.section(pp, "ДВИЖЕНИЕ")
    Util.noclipToggle = Util.toggle(pp, "Noclip", false, function(v) Util.noclipSet(v) end)
    Util.section(pp, "ПОДСКАЗКИ УПРАВЛЕНИЯ")
    local help = Util.card(pp, 50)
    Util.lbl(help, "ПК: клавиши в Настройки → Бинды", 11, C.sub, {Position = UDim2.fromOffset(10, 6), Size = UDim2.new(1, -20, 0, 18)})
    Util.lbl(help, "Телефон: ▲ ▼ появляются справа во время полёта", 11, C.sub, {Position = UDim2.fromOffset(10, 26), Size = UDim2.new(1, -20, 0, 18)})

    -- ================= БОЙ =================
    local pc = Util.page("Бой")
    Util.section(pc, "AIMBOT")
    Util.aimToggle = Util.toggle(pc, "Aimbot", false, function(v) AIM.on = v end)
    Util.segment(pc, "Скорость наводки", modeOpts, function(i) AIM.mode = i end, 1, "aimMode")
    Util.segment(pc, "Куда попадать", hitOpts, function(i) AIM.part = i end, 1, "aimPart")
    Util.slider(pc, "Радиус FOV", 30, 400, 140, function(v) return string.format("%d px", v) end, function(v) AIM.fov = v end, 5, "aimFov")
    Util.toggle(pc, "Aimbot по зажатой ПКМ", true, function(v) AIM.hold = v end, "aimHold")

    Util.section(pc, "AIM ASSIST")
    Util.assistToggle = Util.toggle(pc, "Aim Assist", false, function(v) AIM.assist = v end)
    Util.segment(pc, "Сила помощи", modeOpts, function(i) AIM.amode = i end, 1, "assistMode")
    Util.segment(pc, "Куда помогать", hitOpts, function(i) AIM.apart = i end, 1, "assistPart")
    Util.slider(pc, "Радиус помощи", 30, 300, 90, function(v) return string.format("%d px", v) end, function(v) AIM.afov = v end, 5, "assistFov")

    Util.section(pc, "ЦЕЛЬ")
    Util.slider(pc, "Дальность цели", 50, 1000, 400, function(v) return string.format("%d %s", v, T("ст.")) end, function(v) AIM.range = v end, 10, "aimRange")
    Util.toggle(pc, "Проверка стен", true, function(v) AIM.wall = v end, "aimWall")
    Util.toggle(pc, "Проверка команды", false, function(v) AIM.team = v end, "aimTeam")

    Util.section(pc, "ОТОБРАЖЕНИЕ")
    Util.toggle(pc, "Показывать круг FOV", true, function(v) AIM.showFov = v end, "aimShowFov")
    Util.toggle(pc, "Показывать метку цели", true, function(v) AIM.showLabel = v end, "aimShowLabel")

    Util.section(pc, "УПРАВЛЕНИЕ")
    local combatHelp = Util.card(pc, 30)
    Util.lbl(combatHelp, "Клавиши: Настройки → Бинды", 11, C.sub, {Position = UDim2.fromOffset(10, 0), Size = UDim2.new(1, -20, 1, 0)})

    -- ================= AURA.ME =================
    local pa = Util.page("Aura.Me")
    local function rebuild() if AM.on then Util.auraMeRebuild() end end
    Util.section(pa, "AURA.ME")
    Util.auraToggle = Util.toggle(pa, "Aura.Me", false, function(v) Util.auraMeSet(v) end)
    Util.slider(pa, "Интенсивность", 20, 200, 100, fmtPct, function(v) AM.power = v end, 5, "amPower")
    Util.slider(pa, "Скорость эффектов", 40, 250, 100, fmtPct, function(v) AM.speed = v end, 5, "amSpeed")
    Util.slider(pa, "Количество орбов", 2, 8, 5, int, function(v) AM.orbCount = v; rebuild() end, 1, "amOrbCount", true)
    Util.segment(pa, "Цвет эффектов", {"Акцент", "Градиент", "Радуга"}, function(i) AM.colorMode = i end, 1, "amColor")

    Util.section(pa, "ЭЛЕМЕНТЫ")
    Util.toggle(pa, "Орбы с лучами", true, function(v) AM.orbs = v; rebuild() end, "amOrbs")
    Util.toggle(pa, "Молнии между орбами", true, function(v) AM.arcs = v; rebuild() end, "amArcs")
    Util.toggle(pa, "Столб света", true, function(v) AM.pillar = v; rebuild() end, "amPillar")
    Util.toggle(pa, "Двойная спираль", true, function(v) AM.helix = v; rebuild() end, "amHelix")
    Util.toggle(pa, "Нимб", true, function(v) AM.halo = v; rebuild() end, "amHalo")
    Util.toggle(pa, "Магический круг", true, function(v) AM.sigil = v; rebuild() end, "amSigil")
    Util.toggle(pa, "Крылья света", true, function(v) AM.wings = v; rebuild() end, "amWings")
    Util.toggle(pa, "Частицы и свечение", true, function(v) AM.motes = v; rebuild() end, "amMotes")

    Util.section(pa, "ДЕТАЛИ")
    Util.toggle(pa, "Остаточные образы", true, function(v) AM.ghosts = v end, "amGhosts")
    Util.toggle(pa, "Волны импульса", true, function(v) AM.waves = v end, "amWaves")
    Util.toggle(pa, "Реакция на музыку", true, function(v) AM.music = v end, "amMusic")
    Util.toggle(pa, "Следы рук и ног", true, function(v) AM.trails = v; rebuild() end, "amTrails")
    Util.toggle(pa, "Рябь от шагов", true, function(v) AM.ripples = v; rebuild() end, "amRipples")
end

do
    local Util = __AuraFixUtil
    local ps = __AuraFix_ps
    local KC, UT = Enum.KeyCode, Enum.UserInputType
    local ROWS = {
        {"fly", "Полёт"}, {"noclip", "Noclip"}, {"aimbot", "Aimbot"}, {"assist", "Aim Assist"}, {"aura", "Aura.Me"},
        {"rtx", "Следующий режим RTX"}, {"esp", "ESP вкл/выкл"}, {"nextpart", "Следующая цель попадания"},
        {"up", "Полёт вверх"}, {"down", "Полёт вниз"}, {"hold", "Aimbot по удержанию"}, {"menu", "Открыть/закрыть меню"},
    }

    local function keyName(b)
        if not b then return T("Нет") end
        if b[1] == "M" then
            return b[2] == UT.MouseButton2 and "M2" or (b[2] == UT.MouseButton3 and "M3" or b[2].Name)
        end
        local s = UIS:GetStringForKeyCode(b[2])
        if s and s ~= "" and #s <= 2 then return string.upper(s) end
        return b[2].Name
    end

    local head, headStroke = Util.card(ps, 38)
    Util.lbl(head, "БИНДЫ", 13, C.text, {Position = UDim2.fromOffset(12, 0), Size = UDim2.new(1, -60, 1, 0), Font = Enum.Font.GothamBold})
    local hit = Util.new("TextButton", {Text = "", BackgroundTransparency = 1, AutoButtonColor = false, Size = UDim2.new(1, -48, 1, 0)}, head)
    local arrow = Util.new("TextButton", {Text = "↓", Font = Enum.Font.GothamBlack, TextSize = 18, TextColor3 = WHITE, AutoButtonColor = false, BackgroundColor3 = C.card2, AnchorPoint = Vector2.new(1, .5), Position = UDim2.new(1, -8, .5, 0), Size = UDim2.fromOffset(32, 26)}, head)
    Util.round(arrow, 8)
    Util.press(arrow)
    local arrowStroke = Util.stroke(arrow, 1.5, accent, .55)
    Util.acc(arrowStroke, "Color")

    local body = Util.new("Frame", {Name = "BindBody", BackgroundTransparency = 1, ClipsDescendants = true, Size = UDim2.new(1, 0, 0, 0)}, ps)
    local inner = Util.new("Frame", {BackgroundTransparency = 1, AutomaticSize = Enum.AutomaticSize.Y, Size = UDim2.new(1, 0, 0, 0)}, body)
    local layout = Util.new("UIListLayout", {Padding = UDim.new(0, 5)}, inner)
    Util.new("UIPadding", {PaddingTop = UDim.new(0, 2), PaddingBottom = UDim.new(0, 4)}, inner)

    local hint = Util.card(inner, 40)
    Util.lbl(hint, "Нажми на кнопку, затем на клавишу. Backspace снимает бинд, Esc отменяет.", 10, C.sub, {Position = UDim2.fromOffset(10, 3), Size = UDim2.new(1, -20, 1, -6), TextWrapped = true, TextTruncate = Enum.TextTruncate.None})

    local rowBtns, current, curBtn, curStroke = {}, nil, nil, nil
    local function refresh()
        for id, b in pairs(rowBtns) do
            if current ~= id then b.Text = keyName(Util.binds[id]) end
        end
    end
    trReg[#trReg + 1] = refresh

    local function stopListen()
        if curBtn then
            tw(curStroke, {Transparency = 1}, .2)
            tw(curBtn, {BackgroundColor3 = C.card2}, .2)
        end
        current, curBtn, curStroke = nil, nil, nil
        task.defer(function() if not current then Util.listening = false end end)
        refresh()
    end

    local function startListen(id, b, bs)
        if current then stopListen() end
        current, curBtn, curStroke = id, b, bs
        Util.listening = true
        b.Text = T("Нажмите клавишу...")
        tw(bs, {Transparency = .1}, .2)
        tw(b, {BackgroundColor3 = C.card3}, .2)
    end

    for _, r in ipairs(ROWS) do
        local f = Util.card(inner, 32)
        Util.lbl(f, r[2], 12, nil, {Position = UDim2.fromOffset(10, 0), Size = UDim2.new(1, -118, 1, 0)})
        local b = Util.new("TextButton", {Text = "", Font = Enum.Font.GothamBold, TextSize = 11, TextColor3 = C.text, AutoButtonColor = false, BackgroundColor3 = C.card2, AnchorPoint = Vector2.new(1, .5), Position = UDim2.new(1, -8, .5, 0), Size = UDim2.fromOffset(98, 22)}, f)
        Util.round(b, 6)
        Util.press(b, true)
        local bs = Util.stroke(b, 1.2, accent, 1)
        rowBtns[r[1]] = b
        cn(b.Activated, function() startListen(r[1], b, bs) end)
    end

    Util.button(inner, "Сбросить бинды", function()
        stopListen()
        Util.binds = {}
        for id, def in pairs(Util.defaultBinds) do Util.binds[id] = {def[1], def[2]} end
        cfg.binds = {}
        pcall(Util.saveCfg)
        refresh()
        Util.toast("Бинды сброшены", C.good)
    end)
    refresh()

    cn(UIS.InputBegan, function(i)
        if not current then return end
        local id, ut = current, i.UserInputType
        if ut == UT.Keyboard and i.KeyCode ~= KC.Unknown then
            if i.KeyCode == KC.Escape then stopListen() return end
            if i.KeyCode == KC.Backspace or i.KeyCode == KC.Delete then
                Util.setBind(id, nil)
            else
                Util.setBind(id, {"K", i.KeyCode})
            end
            stopListen()
        elseif ut == UT.MouseButton2 or ut == UT.MouseButton3 then
            Util.setBind(id, {"M", ut})
            stopListen()
        elseif ut == UT.Gamepad1 and i.KeyCode ~= KC.Unknown and not tostring(i.KeyCode):find("Thumbstick") then
            Util.setBind(id, {"K", i.KeyCode})
            stopListen()
        end
    end)

    local open, tok = false, 0
    local function setOpen(v)
        if open == v then return end
        open = v
        tok += 1
        local my = tok
        if not v then stopListen() end
        tw(arrow, {Rotation = v and 180 or 0}, .55, EASE.Back)
        tw(headStroke, {Transparency = v and .25 or .93}, .35)
        local n = 0
        for _, c in ipairs(inner:GetChildren()) do
            if c:IsA("GuiObject") then
                n += 1
                local sc = c:FindFirstChild("Pop") or Util.new("UIScale", {Name = "Pop"}, c)
                if v then
                    sc.Scale = .86
                    task.delay(.08 + n * .035, function()
                        if c.Parent and open and my == tok then tw(sc, {Scale = 1}, .5, EASE.Back) end
                    end)
                else
                    tw(sc, {Scale = .9}, .2)
                end
            end
        end
        if v then
            tw(body, {Size = UDim2.new(1, 0, 0, layout.AbsoluteContentSize.Y + 6)}, .6, EASE.Quint)
            task.delay(.95, function()
                if not (open and my == tok) then return end
                local maxY = math.max(0, ps.AbsoluteCanvasSize.Y - ps.AbsoluteWindowSize.Y)
                TS:Create(ps, TweenInfo.new(.5, EASE.Quint, DIR.Out), {CanvasPosition = Vector2.new(0, maxY)}):Play()
            end)
        else
            tw(body, {Size = UDim2.new(1, 0, 0, 0)}, .5, EASE.Quart, DIR.InOut)
        end
    end
    cn(arrow.Activated, function() setOpen(not open) end)
    cn(hit.Activated, function() setOpen(not open) end)
end

__AuraFix_tabBtns, __AuraFix_cur, __AuraFix_tok = {}, nil, nil
__AuraFix_ind = __AuraFixUtil.new("Frame",
    {Size = UDim2.new(1, 0, 0, __AuraFixUtil.TAB_H),
    BackgroundTransparency = .8},
    side)
__AuraFixUtil.round(__AuraFix_ind,
    8); __AuraFixUtil.acc(__AuraFix_ind,
    "BackgroundColor3")
__AuraFix_ibar = __AuraFixUtil.new("Frame",
    {Size = UDim2.new(0,
    3,
    .6,
    0),
    AnchorPoint = Vector2.new(0,
    .5),
    Position = UDim2.new(0,
    4,
    .5,
    0)},
    __AuraFix_ind)
__AuraFixUtil.round(__AuraFix_ibar,
    2); __AuraFixUtil.acc(__AuraFix_ibar,
    "BackgroundColor3")

function __AuraFix_popIn(name)
	local n = 0
	for _, c in ipairs(pages[name]:GetChildren()) do
		if c:IsA("GuiObject") and c.Visible then
			n += 1
			if n > 12 then break end
			local sc = c:FindFirstChild("Pop") or __AuraFixUtil.new("UIScale", {Name = "Pop"}, c)
			sc.Scale = .92
			task.delay(n * .02, function() if c.Parent and pages[name].Visible then tw(sc, {Scale = 1}, .5, EASE.Back) end end)
		end
	end
end

function __AuraFix_selectTab(name, instant)
	if __AuraFix_cur == name then return end
	local prevIdx = __AuraFix_cur and table.find(order, __AuraFix_cur) or 1
	local newIdx = table.find(order, name)
	local dirY = newIdx >= prevIdx and 1 or -1
	__AuraFix_cur = name
	local my = {}
	__AuraFix_tok = my
	for n, b in pairs(__AuraFix_tabBtns) do tw(b, {TextColor3 = n == name and C.text or C.sub}, .25) end
	tw(__AuraFix_ind, {Position = UDim2.fromOffset(0, (newIdx - 1) * __AuraFixUtil.TAB_STEP)}, .45, EASE.Back)
	local function swap() for n, p in pairs(pages) do p.Visible = n == name end end
	if instant then swap(); __AuraFix_popIn(name) return end
	task.spawn(function()
		tw(content, {GroupTransparency = 1, Position = CPOS + UDim2.fromOffset(0, -8 * dirY)}, .16, EASE.Quad, DIR.In).Completed:Wait()
		if __AuraFix_tok ~= my then return end
		swap()
		content.Position = CPOS + UDim2.fromOffset(0, 12 * dirY)
		__AuraFix_popIn(name)
		tw(content, {GroupTransparency = 0, Position = CPOS}, .4, EASE.Quint)
	end)
end

__AuraFix_tabGlyphs = { ["Музыка"] = "♫",
    ["Эффекты"] = "✦",
    ["Визуал"] = "◈",
    ["Разное"] = "◌",
    ["RTX"] = "◆", ["Игрок"] = "✪", ["Бой"] = "⌖", ["Aura.Me"] = "✧", ["Настройки"] = "⚙" }
for i, name in ipairs(order) do
	local b = __AuraFixUtil.new("TextButton",
	    {Font = Enum.Font.GothamBold,
	    TextSize = 12,
	    TextColor3 = C.sub,
	    TextXAlignment = Enum.TextXAlignment.Left,
	    BackgroundTransparency = 1,
	    AutoButtonColor = false,
	    Position = UDim2.fromOffset(0,
	    (i - 1) * __AuraFixUtil.TAB_STEP),
	    Size = UDim2.new(1, 0, 0, __AuraFixUtil.TAB_H)},
	    side)
	bind(b,
	    name)
	__AuraFixUtil.new("UIPadding",
	    {PaddingLeft = UDim.new(0,
	    31)},
	    b)
	local glyph = __AuraFixUtil.new("TextLabel",
	    {BackgroundTransparency = 1,
	    Font = Enum.Font.GothamBold,
	    TextSize = 16,
	    TextColor3 = C.sub,
	    Text = __AuraFix_tabGlyphs[name] or "•",
	    Position = UDim2.fromOffset(8,
	    0),
	    Size = UDim2.fromOffset(18, __AuraFixUtil.TAB_H),
	    TextXAlignment = Enum.TextXAlignment.Center},
	    side)
	__AuraFixUtil.acc(glyph,
	    "TextColor3",
	    function() return __AuraFix_cur == name and accent or C.sub end)
	__AuraFix_tabBtns[name] = b
	cn(b.Activated,
	    function() __AuraFix_selectTab(name) end)
	cn(b.MouseEnter,
	    function()
		if __AuraFix_cur ~= name then
			tw(b,
			    {TextColor3 = C.text:Lerp(C.sub,
			    .45)},
			    .2)
			tw(glyph,
			    {TextColor3 = accent},
			    .2)
		end
	end)
	cn(b.MouseLeave,
	    function()
		tw(b,
		    {TextColor3 = __AuraFix_cur == name and C.text or C.sub},
		    .25)
		tw(glyph,
		    {TextColor3 = __AuraFix_cur == name and accent or C.sub},
		    .25)
	end)
end

cn(sound.Ended,
    function()
	if sound.Looped then return end
	endedF = true
	if queueAutoPlay and #queueItems > 0 then
		task.delay(.15,
		    function()
			if not sound.IsPlaying and #queueItems > 0 and gui.Parent then
				local nextItem = table.remove(queueItems,
				    1)
				__AuraFix_renderQueue()
				box.Text = nextItem.id
				play(nextItem.id)
			end
		end)
	end
end)
cn(UIS.InputBegan,
    function(i,
    gp)
	if not gp and not __AuraFixUtil.listening and __AuraFixUtil.isBind("menu", i) then __AuraFixUtil.setOpen(not opened) end
end)

__AuraFix_spinV = 0
RS:BindToRenderStep("AuraMenuLoop",
    Enum.RenderPriority.Camera.Value + 1,
    function(dt)
	local t = os.clock()
	if rainbow then
		hue = (hue + dt * .2) % 1
		accent = Color3.fromHSV(hue,
		    .65,
		    1)
		for _, f in ipairs(reg) do f(true) end
	end
	if fovOn then
		local c = workspace.CurrentCamera
		if c then c.FieldOfView += (fovT - c.FieldOfView) * math.min(1,
		    dt * 8) end
	end
	if espAny or espWas then __AuraFixUtil.updateESP(t) end
	espWas = espAny
	if V.fps then
		fpsA += dt; fpsN += 1
		if fpsA >= .4 then
			local f = math.floor(fpsN / fpsA + .5)
			fpsA,
			    fpsN = 0,
			    0
			local ok, ping = pcall(function() return Stats.Network.ServerStatsItem["Data Ping"]:GetValue() end)
			local statusColor = f >= 50 and C.good or (f >= 30 and Color3.fromRGB(255,
			    190,
			    70) or C.bad)
			fpsL.Text = f .. " FPS · " .. (ok and math.floor(ping + .5) .. " ms" or "-- ms")
			tw(fpsD,
			    {BackgroundColor3 = statusColor,
			    Size = UDim2.fromOffset(9,
			    9)},
			    .12,
			    EASE.Sine)
		task.delay(.13,
		    function() if fpsD.Parent then tw(fpsD,
		    {Size = UDim2.fromOffset(8,
		    8)},
		    .22,
		    EASE.Back) end end)
			tw(fpsStroke,
			    {Color = statusColor,
			    Transparency = .23},
			    .18,
			    EASE.Sine)
			fpsS.Scale = 1.035
			tw(fpsS,
			    {Scale = 1},
			    .25,
			    EASE.Back,
			    DIR.Out)
			tw(fpsAura,
			    {BackgroundColor3 = statusColor},
			    .24,
			    EASE.Sine)
		end
	end

	local playing = sound.IsPlaying
    -- PlaybackLoudness is Roblox's available client-side amplitude meter (not a true FFT).
    local rawLoud = playing and math.clamp(sound.PlaybackLoudness / 420,
        0,
        1) or 0
    __AuraFix_audioMeter = __AuraFix_audioMeter or {prev = 0,
        low = 0,
        mid = 0,
        high = 0,
        beat = 0,
        flux = 0}
    local meter = __AuraFix_audioMeter
    local attack = math.max(0,
        rawLoud - meter.prev)
    meter.low += (rawLoud - meter.low) * math.min(1,
        dt * 3.2)
    meter.mid += (rawLoud - meter.mid) * math.min(1,
        dt * 8.5)
    meter.high += (rawLoud - meter.high) * math.min(1,
        dt * 17)
    meter.flux += ((attack * 2.2) - meter.flux) * math.min(1,
        dt * 12)
    meter.beat = math.max(0,
        meter.beat - dt * 2.8)
    if attack > .075 and rawLoud > .12 then meter.beat = math.clamp(attack * 5.5,
        .18,
        1) end
    meter.prev = rawLoud
    local loud = math.clamp(meter.low * .35 + meter.mid * .4 + meter.high * .25 + meter.beat * .18,
        0,
        1)
	-- Original Aurora mode: slow hue drift and a restrained glow pulse, only while enabled.
    if envOn and envPreset == 6 and envStrength > 0 then
        if envSkyIsActive and envSky.Parent == Lighting then
            local skyRotation = envSky.SkyboxOrientation.Y + math.max(0,
                dt) * 1.8
            envSky.SkyboxOrientation = Vector3.new(0,
                skyRotation % 360,
                0)
        end
        envPhase += math.max(0,
            dt) * .22
        envTick += dt
        if envTick >= (1 / 30) then
            envTick = 0
            local wave = (math.sin(envPhase * 1.9) + 1) * .5
            local wave2 = (math.sin(envPhase * 1.27 + 1.4) + 1) * .5
            local hueNow = (.44 + wave * .34 + wave2 * .08) % 1
            __AuraFix_envColor.TintColor = Color3.fromHSV(hueNow,
                .14 + wave * .17,
                1)
            __AuraFix_envColor.Saturation = .10 + wave * .14
            __AuraFix_envBloom.Intensity = math.clamp(envBaseBloom * envStrength / 60 * (.88 + wave * .22),
                0,
                .8)
            __AuraFix_envRays.Intensity = .018 + wave2 * .018
            envAtmo.Color = Color3.fromHSV((hueNow + .02) % 1,
                .35,
                1)
            envAtmo.Decay = Color3.fromHSV((hueNow + .14) % 1,
                .42,
                .58)
        end
    end
	if not main.Visible then return end
	for k, m in ipairs(mini) do
		local target = playing and 3 + (.5 + .5 * math.sin(t * (6 + k * 1.7) + k)) * 9 * (.4 + loud * .6) or 3
		m.h += (target - m.h) * .25
		m.f.Size = UDim2.fromOffset(4,
		    math.floor(m.h + .5))
	end
	if not pages["Музыка"].Visible then return end
	for n, b in ipairs(__AuraFix_bars) do
        local x = (n - 1) / math.max(1,
            #__AuraFix_bars - 1)
        -- Approximate bands from the loudness envelope; Roblox exposes no per-frequency FFT bins.
        local bass = meter.low * (1 - x * .68)
        local midBand = meter.mid * (1 - math.abs(x - .5) * 1.25)
        local treble = meter.high * (.22 + x * .78)
        local ripple = math.abs(math.sin(t * (2.2 + x * 5.5) + n * .63))
        local texture = math.abs(math.sin(t * 1.7 + n * .29) * math.cos(t * 3.1 + n * .17))
        local response = bass * .82 + midBand * .55 + treble * .48 + meter.flux * (.2 + x * .55)
        if visualizerStyle == 2 then
            response = bass * .38 + midBand * .52 + treble * .9 + meter.flux * .75
        elseif visualizerStyle == 3 then
            response = bass * .55 + midBand * .85 + treble * .42 + ripple * meter.beat * .8
        end
        local target = playing and math.clamp(response * (.55 + ripple * .45) + texture * meter.beat * .22,
            0,
            1) or 0
        local easeRate = target > b.h and (18 + meter.flux * 20) or 7.5
        b.h += (target - b.h) * (1 - math.exp(-dt * easeRate))
        b.p = math.max(b.h,
            b.p - dt * (1.8 + meter.high * 3))
        b.f.Size = UDim2.new(1 / 28,
            -3,
            0,
            3 + b.h * 42)
        b.c.Position = UDim2.new((n - 1) / 28,
            2,
            1,
            -11 - b.p * 42)
    end
	__AuraFix_spinV += ((playing and 150 or 0) - __AuraFix_spinV) * math.min(1,
	    dt * 3)
	__AuraFix_vinyl.Rotation = (__AuraFix_vinyl.Rotation + __AuraFix_spinV * dt) % 360
	__AuraFix_vs.Thickness = musicAccentPulse and (2 + loud * 3) or 2
	local len = sound.TimeLength
	if not prog.Dragging then prog.Set(len > 0 and sound.TimePosition / len or 0,
	    true,
	    true) end
	local want = T(playing and "Пауза" or "Играть")
	if pauseB.Text ~= want then pauseB.Text = want end
	if trackOK then
		local s = playing and "Играет" or (sound.IsPaused and "На паузе" or (endedF and "Трек закончился" or "Остановлено"))
		s = T(s)
		if statusL.Text ~= s then __AuraFixUtil.setStatus(s,
		    playing and C.good or C.sub) end
	end
end)

-- Finalize the menu after all original widgets have been constructed.

__AuraFixUtil.applyEnvironmentPreset(envPreset)
__AuraFix_selectTab(order[1], true)
__AuraFixUtil.setOpen(true)
task.delay(.9, function() __AuraFixUtil.toast("AURA загружено") end)
