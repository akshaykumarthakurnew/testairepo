import json
import openai
import os

def parse_tfplan(tfplan_path):
    with open(tfplan_path, 'r') as f:
        tfplan = json.load(f)
    return tfplan

def generate_diagrams_script(tfplan, openai_api_key, output_path):
    openai.api_key = openai_api_key

    resources = tfplan['resource_changes']

    prompt = """
    Generate a Python script using the Diagrams library to visualize the following Terraform resources:
    """

    for resource in resources:
        resource_type = resource['type']
        resource_name = resource['name']
        prompt += f"\n- {resource_type}: {resource_name}"

    response = openai.Completion.create(
        model="text-davinci-003",
        prompt=prompt,
        max_tokens=500
    )

    script_content = response.choices[0].text.strip()

    with open(output_path, 'w') as f:
        f.write(script_content)

if __name__ == "__main__":
    tfplan_path = 'tfplan.json'
    output_path = 'diagram.py'
    openai_api_key = os.getenv('OPENAI_API_KEY')
    
    tfplan = parse_tfplan(tfplan_path)
    generate_diagrams_script(tfplan, openai_api_key, output_path)
