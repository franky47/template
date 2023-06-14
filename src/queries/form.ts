export const insert_one = `
  mutation MyMutation(
    $data: String,
    $publicKey: String,
    $sealedSecret: String,
    $signature: String,
    $submissionBucketId: String,
    $answersFiles: [answers_files_insert_input!]!
  ) {
    insert_answers_one(object: {
      data: $data,
      public_key: $publicKey,
      sealed_secret: $sealedSecret,
      signature: $signature,
      submission_bucket_id: $submissionBucketId
      answers_files: {
        data: $answersFiles
      }
  }) {
      id
    }
  }
`;

export const query = `
  query MyQuery {
    answers {
      created_at
      data
      id
      public_key
      sealed_secret
      signature
      submission_bucket_id
    }
  }
`;