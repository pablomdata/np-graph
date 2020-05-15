def load_amazon_reviews():
    # Read raw data.
    data = []
    with gzip.open('./data/amazon_reviews/reviews_Digital_Music_5.json.gz', 'rt') as f:
        for line in tqdm(f.readlines()):
            # Clean data
            line = line.strip('\n')
            # Parse with JSON
            j = json.loads(line)
            data.append(j)

    # Add nodes
    G = nx.Graph()  # noqa: N806
    for d in tqdm(data):
        G.add_node(d['asin'], bipartite='product')
        G.add_node(d['reviewerID'], bipartite='customer')

    # Add edges
    for d in tqdm(data):
        G.add_edge(d['reviewerID'], d['asin'])

    return G