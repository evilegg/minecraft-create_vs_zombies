#!python3

import click
import jinja2
import json

def load_context(json_file):
    """
    Loads context from a JSON file.
    
    :param json_file: Path to the JSON file containing context data.
    :return: Dictionary containing context variables.
    """
    with open(json_file, 'r') as file:
        context = json.load(file)
    return context

def render_template(template_path, context):
    """
    Renders a Jinja2 template with the given context.
    
    :param template_path: Path to the Jinja2 template file.
    :param context: Dictionary containing context variables for rendering.
    :return: Rendered HTML string.
    """
    with open(template_path, 'r') as file:
        template_content = file.read()
    
    template = jinja2.Template(template_content)
    return template.render(context)

def main():
    """
    Main function to convert JSON to Markdown.
    """
    json_file = 'modrinth.index.json'
    template_file = 'README.md'
    
    # Load context from JSON file
    context = load_context(json_file)
    
    # Render the template with the context
    rendered_content = render_template(template_file, context)
    
    # Write the rendered content to an output file
    print(rendered_content)
    #output_file = 'dist/index.md'
    #with open(output_file, 'w') as file:
        #file.write(rendered_content)
    
    #print(f"Markdown file generated: {output_file}")

if __name__ == "__main__":
    main()