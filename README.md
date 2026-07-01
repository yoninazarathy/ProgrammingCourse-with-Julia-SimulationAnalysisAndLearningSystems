### Render All Documents (HTML & PDF, using parallel rendering)
```bash
make all
```

### Render HTML Only
```bash
make all-html
```

### Render PDF Only
```bash
make all-pdf
```

### Render single lectures
```bash
make lecture-1 assessment-projectA
```


## Configuration

Rendering settings are in `_quarto.yml`:
- **HTML Theme**: Cosmo (clean, modern theme)
- **PDF Engine**: XeLaTeX (handles Unicode well)
- **Code Execution**: **Enabled** (`eval: true`) - All Julia code is executed and outputs are captured
- **Error Handling**: **Enabled** (`error: true`) - Error messages are displayed in the output
- **Warnings**: **Enabled** (`warning: true`) - Warning messages are displayed in the output
- **TOC**: Included with numbered sections
