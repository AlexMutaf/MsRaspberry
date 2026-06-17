extends Node2D

# Background textures
@onready var off_texture = preload("res://assets/sprites/questions/background_off.png");
@onready var on_texture = preload("res://assets/sprites/questions/background_on.png");
@onready var correct_texture = preload("res://assets/sprites/questions/background_cor.png");
@onready var wrong_texture = preload("res://assets/sprites/questions/background_wrong.png");
@onready var background = $Background;
@onready var anim_player = $TransitionLayer/AnimPlayer;

@onready var topic_label = $Topic;
@onready var quest_label = $"Question";
@onready var qnum_label = $"Question Number";
@onready var timer_label = $Timer;
@onready var line = $Line;

@onready var label_A = $"Control/Answer A";
@onready var label_B = $"Control/Answer B";
@onready var label_C = $"Control/Answer C";

@onready var button_A = $"Control/Button A";
@onready var button_B = $"Control/Button B";
@onready var button_C = $"Control/Button C";

const Q_TOPICS: Array[String] = ["Наименувай Елемента"];
var QUESTION_TOPICS: int = Q_TOPICS.size();
const MAX_QUESTION_AMOUNT: int = 60;

var PT_ELEMENTS: Array[elem_t] = [
	# Period 1
	elem_t.new("H", "Водород", "1A"),
	elem_t.new("He", "Хелий", "8A"),

	# Period 2
	elem_t.new("Li", "Литий", "1A"),
	elem_t.new("Be", "Берилий", "2A"),
	elem_t.new("B", "Бор", "3A"),
	elem_t.new("C", "Въглерод", "4A"),
	elem_t.new("N", "Азот", "5A"),
	elem_t.new("O", "Кислород", "6A"),
	elem_t.new("F", "Флуор", "7A"),
	elem_t.new("Ne", "Неон", "8A"),

	# Period 3
	elem_t.new("Na", "Натрий", "1A"),
	elem_t.new("Mg", "Магнезий", "2A"),
	elem_t.new("Al", "Алуминий", "3A"),
	elem_t.new("Si", "Силиций", "4A"),
	elem_t.new("P", "Фосфор", "5A"),
	elem_t.new("S", "Сяра", "6A"),
	elem_t.new("Cl", "Хлор", "7A"),
	elem_t.new("Ar", "Аргон", "8A"),

	# Period 4
	elem_t.new("K", "Калий", "1A"),
	elem_t.new("Ca", "Калций", "2A"),
	elem_t.new("Sc", "Скандий", "3B"),
	elem_t.new("Ti", "Титан", "4B"),
	elem_t.new("V", "Ванадий", "5B"),
	elem_t.new("Cr", "Хром", "6B"),
	elem_t.new("Mn", "Манган", "7B"),
	elem_t.new("Fe", "Желязо", "8B"),
	elem_t.new("Co", "Кобалт", "8B"),
	elem_t.new("Ni", "Никел", "8B"),
	elem_t.new("Cu", "Мед", "1B"),
	elem_t.new("Zn", "Цинк", "2B"),
	elem_t.new("Ga", "Галий", "3A"),
	elem_t.new("Ge", "Германий", "4A"),
	elem_t.new("As", "Арсен", "5A"),
	elem_t.new("Se", "Селен", "6A"),
	elem_t.new("Br", "Бром", "7A"),
	elem_t.new("Kr", "Криптон", "8A"),

	# Period 5
	elem_t.new("Rb", "Рубидий", "1A"),
	elem_t.new("Sr", "Стронций", "2A"),
	elem_t.new("Y", "Итрий", "3B"),
	elem_t.new("Zr", "Цирконий", "4B"),
	elem_t.new("Nb", "Ниобий", "5B"),
	elem_t.new("Mo", "Молибден", "6B"),
	elem_t.new("Tc", "Технеций", "7B"),
	elem_t.new("Ru", "Рутений", "8B"),
	elem_t.new("Rh", "Родий", "8B"),
	elem_t.new("Pd", "Паладий", "8B"),
	elem_t.new("Ag", "Сребро", "1B"),
	elem_t.new("Cd", "Кадмий", "2B"),
	elem_t.new("In", "Индий", "3A"),
	elem_t.new("Sn", "Калай", "4A"),
	elem_t.new("Sb", "Антимон", "5A"),
	elem_t.new("Te", "Телур", "6A"),
	elem_t.new("I", "Йод", "7A"),
	elem_t.new("Xe", "Ксенон", "8A"),

	# Period 6
	elem_t.new("Cs", "Цезий", "1A"),
	elem_t.new("Ba", "Барий", "2A"),
	
	# Lanthanides (Lanthanum is technically 3B, rest are internal to group 3)
	elem_t.new("La", "Лантан", "3B"),
	elem_t.new("Ce", "Церий", "Lanth"),
	elem_t.new("Pr", "Празеодим", "Lanth"),
	elem_t.new("Nd", "Неодим", "Lanth"),
	elem_t.new("Pm", "Прометий", "Lanth"),
	elem_t.new("Sm", "Самарий", "Lanth"),
	elem_t.new("Eu", "Европий", "Lanth"),
	elem_t.new("Gd", "Гадолиний", "Lanth"),
	elem_t.new("Tb", "Тербий", "Lanth"),
	elem_t.new("Dy", "Диспрозий", "Lanth"),
	elem_t.new("Ho", "Холмий", "Lanth"),
	elem_t.new("Er", "Ербий", "Lanth"),
	elem_t.new("Tm", "Тулий", "Lanth"),
	elem_t.new("Yb", "Итербий", "Lanth"),
	elem_t.new("Lu", "Лютеций", "3B"), 
	
	# Transition Metals continued
	elem_t.new("Hf", "Хафний", "4B"),
	elem_t.new("Ta", "Тантал", "5B"),
	elem_t.new("W", "Волфрам", "6B"),
	elem_t.new("Re", "Рений", "7B"),
	elem_t.new("Os", "Осмий", "8B"),
	elem_t.new("Ir", "Иридий", "8B"),
	elem_t.new("Pt", "Платина", "8B"),
	elem_t.new("Au", "Злато", "1B"),
	elem_t.new("Hg", "Живак", "2B"),
	elem_t.new("Tl", "Талий", "3A"),
	elem_t.new("Pb", "Олово", "4A"),
	elem_t.new("Bi", "Бисмут", "5A"),
	elem_t.new("Po", "Полоний", "6A"),
	elem_t.new("At", "Астатий", "7A"),
	elem_t.new("Rn", "Радон", "8A"),

	# Period 7
	elem_t.new("Fr", "Франций", "1A"),
	elem_t.new("Ra", "Радий", "2A"),
	
	# Actinides (Actinium is technically 3B, rest are internal to group 3)
	elem_t.new("Ac", "Актиний", "3B"),
	elem_t.new("Th", "Торий", "Act"),
	elem_t.new("Pa", "Протактиний", "Act"),
	elem_t.new("U", "Уран", "Act"),
	elem_t.new("Np", "Нептуний", "Act"),
	elem_t.new("Pu", "Плутоний", "Act"),
	elem_t.new("Am", "Америций", "Act"),
	elem_t.new("Cm", "Кюрий", "Act"),
	elem_t.new("Bk", "Берклий", "Act"),
	elem_t.new("Cf", "Калифорний", "Act"),
	elem_t.new("Es", "Айнщайний", "Act"),
	elem_t.new("Fm", "Фермий", "Act"),
	elem_t.new("Md", "Менделеевий", "Act"),
	elem_t.new("No", "Нобелий", "Act"),
	elem_t.new("Lr", "Лоуренсий", "3B"),
	
	# Transactinides continued
	elem_t.new("Rf", "Ръдърфордий", "4B"),
	elem_t.new("Db", "Дубний", "5B"),
	elem_t.new("Sg", "Сиборгий", "6B"),
	elem_t.new("Bh", "Борий", "7B"),
	elem_t.new("Hs", "Хасий", "8B"),
	elem_t.new("Mt", "Майтнерий", "8B"),
	elem_t.new("Ds", "Дармщадтий", "8B"),
	elem_t.new("Rg", "Рьонтгений", "1B"),
	elem_t.new("Cn", "Коперниций", "2B"),
	elem_t.new("Nh", "Нихоний", "3A"),
	elem_t.new("Fl", "Флеровий", "4A"),
	elem_t.new("Mc", "Московий", "5A"),
	elem_t.new("Lv", "Ливерморий", "6A"),
	elem_t.new("Ts", "Тенесин", "7A"),
	elem_t.new("Og", "Оганесон", "8A")
];
var ELEM_NUM: int = PT_ELEMENTS.size() - 1;

## 1. Name the Element / O2 -> Oxygen; Oxygen -> O2
## 2. Fill the blank in the chemical reaction / Ca + % -> 2CaO; % -> O2
## 3. What does a chemical reaction equal to:
##    * Ca + O2 -> ???
##    * ??? -> 2CaO

# Text funcs:

func change_text(label_node: RichTextLabel, new_text: String) -> void:
	label_node.text = new_text;
	return;

func typewrite_text(label_node: RichTextLabel, new_text: String) -> void:
	change_text(label_node, new_text);
	label_node.visible_characters = 0;
	var tween: Tween = create_tween();
	var duration: float = new_text.length() * 0.05;
	tween.tween_property(label_node, "visible_characters", new_text.length(), duration);
	return;

func detype_text(label_node: RichTextLabel) -> void:
	var chars: int = label_node.visible_characters;
	var tween: Tween = create_tween();
	var duration: float = chars * 0.03;
	tween.tween_property(label_node, "visible_characters", 0, duration);
	await tween.finished;
	change_text(label_node, "");
	return;


# Font funcs
const NORMAL_FONT_SIZE: int = 110;

func reset_font_size(label_node: RichTextLabel) -> void:
	label_node.add_theme_font_size_override("normal_font_size", NORMAL_FONT_SIZE);
	return;

func set_perfect_font(label_node: RichTextLabel, text: String):
	reset_font_size(quest_label);
	var max_font_size: int = NORMAL_FONT_SIZE;
	var min_font_size: int = 10;
	var current_font: Font = label_node.get_theme_font("normal_font");
	
	if (!current_font):
		current_font = ThemeDB.get_fallback_font();
	var max_allowed_width: float = label_node.size.x;
	var max_allowed_height: float = label_node.size.y;
	var optimal_size: int = max_font_size;
	for size_guess in range(max_font_size, min_font_size - 1, -1):
			var text_size: Vector2 = current_font.get_string_size(text, HORIZONTAL_ALIGNMENT_LEFT, -1, size_guess);
			if (text_size.x <= max_allowed_width && text_size.y <= max_allowed_height):
				optimal_size = size_guess;
				break;
	label_node.add_theme_font_size_override("normal_font_size", optimal_size);
	return;


# Other funcs

func _on_to_main_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn");
	return;
	
func start_fade_sequence() -> void:
	anim_player.play("fade_out");
	await anim_player.animation_finished;
	await Sleep(0.7);
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn");
	return;

func change_background() -> void:
	if (background.texture == off_texture):
		background.texture = on_texture;
	else:
		background.texture = off_texture;
	return;

func flick_background(ans: bool) -> void:
	var flick: Texture2D;
	if (ans == true):
		flick = correct_texture;
		$"Correct Sound".play();
	else:
		flick = wrong_texture;
		$"Wrong Sound".play();
	background.texture = flick;
	await Sleep(0.4);
	background.texture = on_texture;

func Sleep(amount: float) -> void:
	await get_tree().create_timer(amount).timeout
	return;


# Answer funcs

func set_answers(answers: Array[ans_t]) -> void:
	change_text(label_A, " А) " + answers[0].ans);
	change_text(label_B, " Б) " + answers[1].ans);
	change_text(label_C, " В) " + answers[2].ans);
	return;

func hide_or_show_ans():
	if label_A.visible:
		label_A.hide();
		label_B.hide();
		label_C.hide();
	else:
		label_A.show();
		label_B.show();
		label_C.show();
	return;

func check_same_ans(num_range: int, new_elem: int, answers: Array[ans_t]) -> bool:
	for i in range(0, num_range):
		if (new_elem == answers[i].elem):
			return false;
	return true;


# Other, other funcs

var cur_choice = -1;
func check_user_ans(ordered_ans: Array[bool]) -> bool:
	cur_choice = -1;
	var timer = get_tree().create_timer(10.0);
	while (cur_choice == -1 && timer.time_left > 0):
		change_text(timer_label, "00:0" + str(int(timer.time_left)) + " ");
		await get_tree().process_frame;
	if (cur_choice == -1):
		# Ran out of time
		return false;
	return ordered_ans[cur_choice];

var last_topic = -1;
func choose_next_topic() -> int:
	while true:
		var topic: int = randi_range(0, QUESTION_TOPICS - 1);
		if (topic != last_topic || true): # REMOVE TRUE STATEMENT
			last_topic = topic;
			return topic;
	return -1;

var gotten_elements: Dictionary = {};

func guess_elements() -> Array[bool]:
	if (gotten_elements.size() > 10):
		gotten_elements = {};
	var mode: int = randi_range(0, 1);
	var chosen_elem: int = randi_range(0, ELEM_NUM);
	while (gotten_elements.has(chosen_elem)):
		chosen_elem = randi_range(0, ELEM_NUM);
	gotten_elements[chosen_elem] = true;
	var answers: Array[ans_t] = [ans_t.new("", chosen_elem, false), 
								 ans_t.new("", chosen_elem, false),
								 ans_t.new("", chosen_elem, false)];
	for i in range(0, 3):
		while (answers[i].elem == chosen_elem || check_same_ans(i, answers[i].elem, answers) == false):
			var new_elem: int = randi_range(0, ELEM_NUM);
			answers[i] = ans_t.new(PT_ELEMENTS[new_elem].elemnt[mode ^ 1], new_elem, false);
	answers[randi_range(0, 2)] = ans_t.new(PT_ELEMENTS[chosen_elem].elemnt[mode ^ 1], chosen_elem, true);
	
	var display_quest: String = PT_ELEMENTS[chosen_elem].elemnt[mode];
	set_perfect_font(quest_label, " " + display_quest);
	change_text(quest_label, " " + display_quest);
	set_answers(answers);
	return [answers[0].cor, answers[1].cor, answers[2].cor];

func execute_topic(qs_done: int, next_qs: int) -> void:
	var cur_topic: int = choose_next_topic();
	await typewrite_text(topic_label, Q_TOPICS[cur_topic]);
	await Sleep(3);
	await detype_text(topic_label);
	await Sleep(1);
	for i in range(1, next_qs + 1):
		var ordered_ans: Array[bool];
		if (cur_topic == 0):
			ordered_ans = guess_elements();
		change_text(qnum_label, str((i + qs_done)) + ".");
		qnum_label.show();
		quest_label.show();
		line.show();
		timer_label.show();
		hide_or_show_ans();
		var user_ans: bool = await check_user_ans(ordered_ans);
		quest_label.hide();
		line.hide();
		timer_label.hide();
		qnum_label.hide();
		hide_or_show_ans();
		await flick_background(user_ans);
		await Sleep(1);
	return;

func _ready() -> void:
	button_A.pressed.connect(func(): cur_choice = 0);
	button_B.pressed.connect(func(): cur_choice = 1);
	button_C.pressed.connect(func(): cur_choice = 2);
	await Sleep(1.5);
	change_background();
	await Sleep(1.2);
	var qs_done: int = 0;
	while (qs_done < MAX_QUESTION_AMOUNT):
		var next_qs: int = 0;
		while (true):
			next_qs = randi_range(1, MAX_QUESTION_AMOUNT / 3);
			if next_qs + qs_done <= MAX_QUESTION_AMOUNT:
				break;
		await execute_topic(qs_done, next_qs);
		qs_done += next_qs;
	await Sleep(1.2);
	await change_background();
	await Sleep(1);
	start_fade_sequence();
	return;
