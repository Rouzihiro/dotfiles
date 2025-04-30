# Miller (mlr) - Basic Usage Guide

[`miller`](https://github.com/johnkerl/miller) (mlr) is a command-line tool for processing structured text data such as CSV, TSV, and JSON. It is powerful for filtering, sorting, grouping, and transforming tabular data efficiently.

---

## Basic Usage

### 1. Print a CSV file as a table
```sh
mlr --csv cat data.csv
```
<button onclick="copyToClipboard('mlr --csv cat data.csv')">Copy</button>

### 2. Convert CSV to JSON
```sh
mlr --csv tojson data.csv
```
<button onclick="copyToClipboard('mlr --csv tojson data.csv')">Copy</button>

### 3. Select specific columns
```sh
mlr --csv cut -f name,age data.csv
```
<button onclick="copyToClipboard('mlr --csv cut -f name,age data.csv')">Copy</button>

### 4. Filter rows (e.g., age > 30)
```sh
mlr --csv filter '$age > 30' data.csv
```
<button onclick="copyToClipboard('mlr --csv filter \"$age > 30\" data.csv')">Copy</button>

### 5. Sort by a column
```sh
mlr --csv sort -f age data.csv
```
<button onclick="copyToClipboard('mlr --csv sort -f age data.csv')">Copy</button>

### 6. Perform aggregations
```sh
mlr --csv stats1 -a mean,min,max -f age data.csv
```
<button onclick="copyToClipboard('mlr --csv stats1 -a mean,min,max -f age data.csv')">Copy</button>

---

## More Resources
- Official Repo: [https://github.com/johnkerl/miller](https://github.com/johnkerl/miller)
- Documentation: [https://miller.readthedocs.io/](https://miller.readthedocs.io/)

<script>
function copyToClipboard(text) {
  navigator.clipboard.writeText(text).then(() => {
    alert('Copied to clipboard!');
  }, () => {
    alert('Failed to copy.');
  });
}
</script>


