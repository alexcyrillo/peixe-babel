import os
from pypdf import PdfWriter, PdfReader

def merge_pdfs():
    output_path = "site/pdf/tcc-peixe-babel-completo.pdf"
    generated_pdf_path = "site/pdf/tcc-peixe-babel.pdf"
    external_pdfs_dir = "pdf_externos"
    
    writer = PdfWriter()
    
    # 1. Adicionar páginas externas (se existirem)
    total_external_pages = 0
    if os.path.exists(external_pdfs_dir):
        files = sorted([f for f in os.listdir(external_pdfs_dir) if f.endswith(".pdf")])
        print(f"Encontrados {len(files)} arquivos externos em '{external_pdfs_dir}':")
        for filename in files:
            path = os.path.join(external_pdfs_dir, filename)
            reader = PdfReader(path)
            num_pages = len(reader.pages)
            total_external_pages += num_pages
            print(f"  - Adicionando: {filename} ({num_pages} páginas)")
            for page in reader.pages:
                writer.add_page(page)
        print(f"Total de páginas externas: {total_external_pages}")
    else:
        print(f"Diretório '{external_pdfs_dir}' não encontrado. Criando diretório...")
        os.makedirs(external_pdfs_dir)
        print(f"Por favor, coloque os 6 arquivos PDF externos em '{external_pdfs_dir}' e execute novamente.")
        return

    # 2. Adicionar o PDF gerado pelo MkDocs (removendo as 6 páginas em branco iniciais)
    if os.path.exists(generated_pdf_path):
        print(f"Adicionando conteúdo gerado: {generated_pdf_path}")
        reader = PdfReader(generated_pdf_path)
        # Skip the first 6 pages (which are the blank padding pages)
        # Ensure we don't crash if PDF has fewer than 6 pages (unlikely)
        start_page = 6 if len(reader.pages) > 6 else 0
        
        print(f"  - Ignorando as primeiras {start_page} páginas (padding)...")
        for i, page in enumerate(reader.pages):
            if i >= start_page:
                writer.add_page(page)
    else:
        print(f"Erro: PDF gerado não encontrado em '{generated_pdf_path}'. Execute 'mkdocs build' primeiro.")
        return

    # 3. Salvar o resultado final
    with open(output_path, "wb") as f:
        writer.write(f)
    
    print(f"\nPDF Completo gerado com sucesso: {output_path}")
    print(f"Total de páginas: {len(writer.pages)}")

if __name__ == "__main__":
    merge_pdfs()
