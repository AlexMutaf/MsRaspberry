extends Node2D

@onready var off_texture = preload("res://assets/sprites/questions/background_off.png")
@onready var on_texture = preload("res://assets/sprites/questions/background_on.png")

@onready var background = $Background
@onready var anim_player = $TransitionLayer/AnimPlayer
@onready var transit_layer = $TransitionLayer/AnimPlayer


@onready var topic = $Topic
@onready var q_num = $"Question Number"
@onready var quest = $"Question"
@onready var ST = $ST

const Q_TOPICS = ["Найменувай Елемента"]
const MAX_QUESTION_AMOUNT = 3;
var QUESTION_TOPICS = Q_TOPICS.size();

var last_topic = -1

var elements: Array[Array] = [
	[
		"H", "He", "Li", "Be", "B", "C", "N", "O", "F", "Ne", 
		"Na", "Mg", "Al", "Si", "P", "S", "Cl", "Ar", "K", "Ca", 
		"Sc", "Ti", "V", "Cr", "Mn", "Fe", "Co", "Ni", "Cu", "Zn", 
		"Ga", "Ge", "As", "Se", "Br", "Kr", "Rb", "Sr", "Y", "Zr", 
		"Nb", "Mo", "Tc", "Ru", "Rh", "Pd", "Ag", "Cd", "In", "Sn", 
		"Sb", "Te", "I", "Xe", "Cs", "Ba", "La", "Ce", "Pr", "Nd", 
		"Pm", "Sm", "Eu", "Gd", "Tb", "Dy", "Ho", "Er", "Tm", "Yb", 
		"Lu", "Hf", "Ta", "W", "Re", "Os", "Ir", "Pt", "Au", "Hg", 
		"Tl", "Pb", "Bi", "Po", "At", "Rn", "Fr", "Ra", "Ac", "Th", 
		"Pa", "U", "Np", "Pu", "Am", "Cm", "Bk", "Cf", "Es", "Fm", 
		"Md", "No", "Lr", "Rf", "Db", "Sg", "Bh", "Hs", "Mt", "Ds", 
		"Rg", "Cn", "Nh", "Fl", "Mc", "Lv", "Ts", "Og"
	],
	[
		"Водород", "Хелий", "Литий", "Берилий", "Бор", "Въглерод", "Азот",
		"Кислород", "Флуор", "Неон", "Натрий", "Магнезий", "Алуминий", "Силиций",
		"Фосфор", "Сяра", "Хлор", "Аргон", "Калий", "Калций", "Скандий", "Титан",
		"Ванадий", "Хром", "Манган", "Желязо", "Кобалт", "Никел", "Мед", "Цинк",
		"Галий", "Германий", "Арсен", "Селен", "Бром", "Криптон", "Рубидий", "Стронций",
		"Итрий", "Цирконий","Ниобий", "Молибден", "Технеций", "Рутений", "Родий", "Паладий",
		"Сребро", "Кадмий", "Индий", "Калай", "Антимон", "Телур", "Йод", "Ксенон", "Цезий",
		"Барий", "Лантан", "Церий", "Празеодим", "Неодим", "Прометий", "Самарий", "Европий",
		"Гадолиний", "Тербий", "Диспрозий", "Холмий", "Ербий", "Тулий", "Итербий", "Лютеций",
		"Хафний", "Тантал", "Вулфрам", "Рений", "Осмий", "Иридий", "Платина", "Злато", "Живак",
		"Талий", "Олово", "Бисмут", "Полоний", "Астатий", "Радон", "Франций", "Радий", "Актиний",
		"Торий", "Протактиний", "Уран", "Нептуний", "Плутоний", "Америций", "Кюрий", "Берклий",
		"Калифорний", "Айнщайний", "Фермий", "Менделеевий", "Нобелий", "Лоуренсий", "Ръдърфордий",
		"Дубний", "Сиборгий", "Борий", "Хасий", "Майтнерий", "Дармщадтий", "Рьонтгений", "Коперниций",
		"Нихоний", "Флеровий", "Московий", "Ливерморий", "Тенесин", "Оганесон"
	]
]

## 1. Name the Element / O2 -> Oxygen; Oxygen -> O2
## 2. Fill the blank in the chemical reaction / Ca + % -> 2CaO; % -> O2
## 3. What does a chemical reaction equal to:
##    * Ca + O2 -> ???
##    * ??? -> 2CaO
## 4. -

func Sleep(amount: int):
	await get_tree().create_timer(amount).timeout

func change_background():
	if background.texture == off_texture:
		background.texture = on_texture
	else:
		background.texture = off_texture

func typewrite_text(label_node: RichTextLabel, new_text: String):
	label_node.text = new_text
	label_node.visible_characters = 0
	
	var tween = create_tween()
	var duration = new_text.length() * 0.05
	tween.tween_property(label_node, "visible_characters", new_text.length(), duration)

func detype_text(label_node: RichTextLabel):
	var chars = label_node.visible_characters
	var tween = create_tween()
	var duration = chars * 0.03
	tween.tween_property(label_node, "visible_characters", 0, duration)
	await tween.finished
	label_node.text = ""

func change_text(label_node: RichTextLabel, new_text: String):
	label_node.text = new_text

func start_fade_sequence():
	anim_player.play("fade_out")
	await anim_player.animation_finished
	await Sleep(0.7)
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

func choose_next_topic():
	while true:
		var topic = randi_range(0, QUESTION_TOPICS - 1)
		if(topic != last_topic || true): # REMOVE TRUE STATEMENT
			last_topic = topic
			return topic

func guess_elements():
	var arr_elements = elements[1].size()
	var mode = randi_range(0, 1)
	var chosen_elem = randi_range(0, arr_elements - 1)
	change_text(quest, elements[mode][chosen_elem])
	quest.show()

func execute_topic(qs_done: int, next_qs: int):
	var cur_topic = choose_next_topic()
	await typewrite_text(topic, Q_TOPICS[cur_topic])
	await Sleep(3)
	await detype_text(topic)
	await Sleep(1.2)
	for i in range(1, next_qs + 1):
		change_text(q_num, str((i + qs_done)) + ".")
		q_num.show()
		if (cur_topic == 0):
			await guess_elements()
		await Sleep(3)
		quest.hide()
		q_num.hide()
		await Sleep(1.5)
	return


func _ready():
	await Sleep(1.75)
	change_background()
	await Sleep(1.2)
	var qs_done = 0
	while qs_done < MAX_QUESTION_AMOUNT:
		var next_qs = 0
		while true:
			next_qs = randi_range(1, MAX_QUESTION_AMOUNT / 3)
			if next_qs + qs_done <= MAX_QUESTION_AMOUNT:
				break
		await execute_topic(qs_done, next_qs)
		qs_done += next_qs
	await Sleep(1.2)
	await change_background()
	await Sleep(1)
	start_fade_sequence()
