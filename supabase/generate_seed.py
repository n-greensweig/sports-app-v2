import json
import os

# Configuration
SPORT_ID = "0105433b-5bdd-4093-b6b1-157a0c3c515e" # Existing Football ID
MODULE_ID = "11111111-1111-1111-1111-111111111111" # Existing Football Basics Module ID
AUTHOR_ID_SQL = "(SELECT id FROM users LIMIT 1)" # Use first user as author

def get_lesson_id(index):
    return f"00000001-0000-0000-0000-0000000000{index:02d}"

def get_item_id(lesson_index, item_index):
    return f"100000{lesson_index:02d}-0000-0000-0000-0000000000{item_index:02d}"

def get_variant_id(lesson_index, item_index):
    return f"200000{lesson_index:02d}-0000-0000-0000-0000000000{item_index:02d}"

def escape_sql(text):
    if text is None:
        return "NULL"
    return "'" + text.replace("'", "''") + "'"

def generate_sql():
    # Load JSON content
    lessons = []
    
    # Part 1
    with open('../content/module1_basics.json', 'r') as f:
        data = json.load(f)
        lessons.extend(data['module']['lessons'])
        
    # Part 2
    with open('../content/module1_basics_part2.json', 'r') as f:
        data = json.load(f)
        lessons.extend(data['additional_lessons'])
        
    # Part 3
    with open('../content/module1_basics_part3.json', 'r') as f:
        data = json.load(f)
        lessons.extend(data['final_lessons'])
        
    print(f"-- Generated Seed Script for Module 1 ({len(lessons)} lessons)")
    print("-- Run this in Supabase SQL Editor")
    print("")
    
    # Sport (Update existing)
    print(f"-- 1. Ensure Football Sport exists")
    print(f"INSERT INTO sports (id, slug, name, is_active, order_index, created_at, updated_at)")
    print(f"VALUES ('{SPORT_ID}', 'football', 'Football', true, 1, now(), now())")
    print(f"ON CONFLICT (slug) DO UPDATE SET name = EXCLUDED.name;")
    print("")
    
    # Module (Update existing)
    print(f"-- 2. Ensure Football Basics Module exists")
    print(f"INSERT INTO modules (id, sport_id, title, description, order_index, min_level, max_level, xp_reward, created_at, updated_at)")
    print(f"VALUES ('{MODULE_ID}', '{SPORT_ID}', 'Football Basics', 'Master the fundamentals of football', 1, 1, 2, 0, now(), now())")
    print(f"ON CONFLICT (id) DO UPDATE SET title = EXCLUDED.title, description = EXCLUDED.description;")
    print("")
    
    # Lessons
    print(f"-- 3. Insert Lessons and Items")
    
    for i, lesson in enumerate(lessons, 1):
        lesson_id = get_lesson_id(i)
        title = escape_sql(lesson['title'])
        desc = escape_sql(lesson['description'])
        minutes = lesson['est_minutes']
        xp = lesson['xp_award']
        
        print(f"-- Lesson {i}: {lesson['title']}")
        print(f"INSERT INTO lessons (id, module_id, title, description, order_index, est_minutes, xp_award, is_locked, created_at, updated_at)")
        is_locked = "false" if i == 1 else "true"
        print(f"VALUES ('{lesson_id}', '{MODULE_ID}', {title}, {desc}, {i}, {minutes}, {xp}, {is_locked}, now(), now())")
        print(f"ON CONFLICT (id) DO UPDATE SET title = EXCLUDED.title, description = EXCLUDED.description, est_minutes = EXCLUDED.est_minutes;")
        
        # Items
        for j, item in enumerate(lesson['items'], 1):
            item_id = get_item_id(i, j)
            variant_id = get_variant_id(i, j)
            
            base_prompt = escape_sql(item['base_prompt'])
            difficulty = item['difficulty']
            
            # Construct answer_schema_json
            # Assuming MCQ for now as per content
            options = item['variant']['options_json']
            correct_index = item['variant']['correct_answer_json']['index']
            
            schema = {
                "type": "mcq",
                "options": options,
                "correct": correct_index
            }
            schema_json = escape_sql(json.dumps(schema))
            
            print(f"  -- Item {j}")
            print(f"  INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, difficulty, status, author_id, created_at, updated_at)")
            print(f"  VALUES ('{item_id}', '{lesson_id}', 'mcq', {base_prompt}, {schema_json}::jsonb, {difficulty}, 'live', {AUTHOR_ID_SQL}, now(), now())")
            print(f"  ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt, answer_schema_json = EXCLUDED.answer_schema_json;")
            
            # Variant
            prompt = escape_sql(item['variant']['prompt_richtext'])
            explanation = escape_sql(item['variant']['explanation_richtext'])
            options_json = escape_sql(json.dumps(options))
            correct_json = escape_sql(json.dumps(item['variant']['correct_answer_json']))
            
            print(f"  INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active, created_at, updated_at)")
            print(f"  VALUES ('{variant_id}', '{item_id}', 1, {prompt}, {options_json}::jsonb, {correct_json}::jsonb, {explanation}, true, now(), now())")
            print(f"  ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, explanation_richtext = EXCLUDED.explanation_richtext;")
            
        print("")

if __name__ == "__main__":
    generate_sql()
