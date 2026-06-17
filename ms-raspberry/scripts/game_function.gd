extends Node2D

@onready var off_texture = preload("res://assets/sprites/questions/background_off.png")
@onready var on_texture = preload("res://assets/sprites/questions/background_on.png")
@onready var correct_texture = preload("res://assets/sprites/questions/background_cor.png")
@onready var wrong_texture = preload("res://assets/sprites/questions/background_wrong.png")

@onready var background = $Background
@onready var anim_player = $TransitionLayer/AnimPlayer

@onready var topic_label = $Topic
@onready var quest_num = $"Question Number"
@onready var quest_label = $"Question"
@onready var timer_label = $Timer
@onready var ST = $ST
@onready var line = $Line

@onready var LAB_A = $"Control/Answer A"
@onready var LAB_B = $"Control/Answer B"
@onready var LAB_C = $"Control/Answer C"

@onready var BUT_A = $"Control/Button A"
@onready var BUT_B = $"Control/Button B"
@onready var BUT_C = $"Control/Button C"

const Q_TOPICS = ["Наименувай Елемента"]
const MAX_QUESTION_AMOUNT = 60;
var QUESTION_TOPICS = Q_TOPICS.size();

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

# Text funcs:

func change_text(label_node: RichTextLabel, new_text: String):
	label_node.text = new_text

func typewrite_text(label_node: RichTextLabel, new_text: String):
	change_text(label_node, new_text)
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
	change_text(label_node, "")


# Font funcs
const NORMAL_FONT_SIZE = 110

func reset_font_size(label_node: RichTextLabel):
	label_node.add_theme_font_size_override("normal_font_size", NORMAL_FONT_SIZE)

func set_perfect_font(label_node: RichTextLabel, text: String):
	reset_font_size(quest_label)
	var max_font_size = 110
	var min_font_size = 10
	
	var current_font: Font = label_node.get_theme_font("normal_font")
	if !(current_font):
		current_font = ThemeDB.get_fallback_font()
		
	var max_allowed_width: float = label_node.size.x
	var max_allowed_height: float = label_node.size.y
	
	var optimal_size = max_font_size
	
	for size_guess in range(max_font_size, min_font_size - 1, -1):
			var text_size: Vector2 = current_font.get_string_size(text, HORIZONTAL_ALIGNMENT_LEFT, -1, size_guess)
			if text_size.x <= max_allowed_width && text_size.y <= max_allowed_height:
				optimal_size = size_guess
				break
	label_node.add_theme_font_size_override("normal_font_size", optimal_size)


# Other funcs

func _on_to_main_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
	
func start_fade_sequence():
	anim_player.play("fade_out")
	await anim_player.animation_finished
	await Sleep(0.7)
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

func change_background():
	if background.texture == off_texture:
		background.texture = on_texture
	else:
		background.texture = off_texture

func flick_background(ans: bool):
	var flick
	if (ans == true):
		flick = correct_texture
		$"Correct Sound".play()
	else:
		flick = wrong_texture
		$"Wrong Sound".play()
		
	background.texture = flick
	await Sleep(0.4)
	background.texture = on_texture

func Sleep(amount: float):
	await get_tree().create_timer(amount).timeout


# Answer funcs

func set_answers(answers: Array[ans_t]):
	change_text(LAB_A, " А) " + answers[0].ans)
	change_text(LAB_B, " Б) " + answers[1].ans)
	change_text(LAB_C, " В) " + answers[2].ans)

func hide_or_show_ans():
	if LAB_A.visible:
		LAB_A.hide()
		LAB_B.hide()
		LAB_C.hide()
	else:
		LAB_A.show()
		LAB_B.show()
		LAB_C.show()

func check_same_ans(num_range: int, new_elem: int, answers: Array[ans_t]) -> bool:
	for i in range(0, num_range):
		if (new_elem == answers[i].elem):
			return false
	return true


# Other, other funcs

var cur_choice = -1
func check_user_ans(ordered_ans: Array[bool]) -> bool:
	cur_choice = -1
	var timer = get_tree().create_timer(10.0)
	while cur_choice == -1 and timer.time_left > 0:
		change_text(timer_label, "00:0" + str(int(timer.time_left)) + " ")
		await get_tree().process_frame
	if cur_choice == -1:
		# Ran out of time
		return false
	return ordered_ans[cur_choice]

var last_topic = -1
func choose_next_topic():
	while true:
		var topic = randi_range(0, QUESTION_TOPICS - 1)
		if(topic != last_topic || true): # REMOVE TRUE STATEMENT
			last_topic = topic
			return topic

var gotten_elements: Dictionary = {}
func guess_elements() -> Array[bool]:
	if (gotten_elements.size() > 10):
		gotten_elements = {};
	var arr_elements = elements[1].size() - 1
	var mode = randi_range(0, 1)
	var chosen_elem = randi_range(0, arr_elements)
	while (gotten_elements.has(chosen_elem)):
		chosen_elem = randi_range(0, arr_elements)
	gotten_elements[chosen_elem] = true
	var answers: Array[ans_t] = [ans_t.new("", chosen_elem, false), 
								 ans_t.new("", chosen_elem, false),
								 ans_t.new("", chosen_elem, false)]
	for i in range(0, 3):
		while answers[i].elem == chosen_elem || check_same_ans(i, answers[i].elem, answers) == false:
			var new_elem = randi_range(0, arr_elements)
			answers[i] = ans_t.new(elements[mode ^ 1][new_elem], new_elem, false)
	answers[randi_range(0, 2)] = ans_t.new(elements[mode ^ 1][chosen_elem], chosen_elem, true)
	
	var display_quest: String = elements[mode][chosen_elem]
	set_perfect_font(quest_label, " " + display_quest)
	change_text(quest_label, " " + display_quest)
	
	set_answers(answers)
	
	return [answers[0].cor, answers[1].cor, answers[2].cor];

func execute_topic(qs_done: int, next_qs: int):
	var cur_topic: int = choose_next_topic()
	await typewrite_text(topic_label, Q_TOPICS[cur_topic])
	await Sleep(3)
	await detype_text(topic_label)
	
	await Sleep(1)
	for i in range(1, next_qs + 1):
		var ordered_ans: Array[bool];
		if (cur_topic == 0):
			ordered_ans = guess_elements()
		change_text(quest_num, str((i + qs_done)) + ".")
		quest_num.show()
		quest_label.show()
		line.show()
		timer_label.show()
		hide_or_show_ans()
		var user_ans: bool = await check_user_ans(ordered_ans)
		quest_label.hide()
		line.hide()
		timer_label.hide()
		quest_num.hide()
		hide_or_show_ans()
		await flick_background(user_ans)
		await Sleep(1)
	return

func _ready():
	BUT_A.pressed.connect(func(): cur_choice = 0)
	BUT_B.pressed.connect(func(): cur_choice = 1)
	BUT_C.pressed.connect(func(): cur_choice = 2)
	
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
