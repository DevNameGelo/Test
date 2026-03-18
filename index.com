                li.innerHTML = `<a href="${file.url}" download>${file.name}</a> \n (Password protected: ${file.password ? 'Yes' : 'No'})`;
                fileList.appendChild(li);
            });
        }

        function handleFiles(files) {
            [...files].forEach(file => {
                const password = document.getElementById('password').value;
                const fileObject = { name: file.name, url: URL.createObjectURL(file), password };
                filesData.push(fileObject);
            });
            localStorage.setItem('filesData', JSON.stringify(filesData));
            renderFiles();
        }

        dropArea.addEventListener('dragover', e => {
            e.preventDefault();
        });

        dropArea.addEventListener('drop', e => {
            e.preventDefault();
            handleFiles(e.dataTransfer.files);
        });

        fileInput.addEventListener('change', e => {
            handleFiles(e.target.files);
        });

        uploadBtn.addEventListener('click', () => {
            const files = fileInput.files;
            handleFiles(files);
        });

        searchInput.addEventListener('input', () => {
            const searchTerm = searchInput.value.toLowerCase();
            const filteredFiles = filesData.filter(file => file.name.toLowerCase().includes(searchTerm));
            fileList.innerHTML = '';
            filteredFiles.forEach(file => {
                const li = document.createElement('li');
                li.innerHTML = `<a href="${file.url}" download>${file.name}</a>`;
                fileList.appendChild(li);
            });
        });

        renderFiles();
    </script>
</body>
</html>
