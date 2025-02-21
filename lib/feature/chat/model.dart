class ChatCompletion {
  final String id;
  final String object;
  final int created;
  final String model;
  final String systemFingerprint;
  final List<Choice> choices;
  final Usage usage;

  ChatCompletion({
    required this.id,
    required this.object,
    required this.created,
    required this.model,
    required this.systemFingerprint,
    required this.choices,
    required this.usage,
  });

  factory ChatCompletion.fromJson(Map<String, dynamic> json) {
    return ChatCompletion(
      id: json['id'],
      object: json['object'],
      created: json['created'],
      model: json['model'],
      systemFingerprint: json['system_fingerprint'],
      choices: (json['choices'] as List).map((i) => Choice.fromJson(i)).toList(),
      usage: Usage.fromJson(json['usage']),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'object': object,
    'created': created,
    'model': model,
    'system_fingerprint': systemFingerprint,
    'choices': choices.map((i) => i.toJson()).toList(),
    'usage': usage.toJson(),
  };
}

class Choice {
  final int index;
  final Message message;
  final dynamic logprobs;
  final String finishReason;

  Choice({
    required this.index,
    required this.message,
    this.logprobs,
    required this.finishReason,
  });

  factory Choice.fromJson(Map<String, dynamic> json) {
    return Choice(
      index: json['index'],
      message: Message.fromJson(json['message']),
      logprobs: json['logprobs'],
      finishReason: json['finish_reason'],
    );
  }

  Map<String, dynamic> toJson() => {
    'index': index,
    'message': message.toJson(),
    'logprobs': logprobs,
    'finish_reason': finishReason,
  };
}

class Message {
  final String role;
  final String content;

  Message({
    required this.role,
    required this.content,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      role: json['role'],
      content: json['content'],
    );
  }

  Map<String, dynamic> toJson() => {
    'role': role,
    'content': content,
  };
}

class Usage {
  final int promptTokens;
  final int completionTokens;
  final int totalTokens;
  final CompletionTokensDetails completionTokensDetails;

  Usage({
    required this.promptTokens,
    required this.completionTokens,
    required this.totalTokens,
    required this.completionTokensDetails,
  });

  factory Usage.fromJson(Map<String, dynamic> json) {
    return Usage(
      promptTokens: json['prompt_tokens'],
      completionTokens: json['completion_tokens'],
      totalTokens: json['total_tokens'],
      completionTokensDetails: CompletionTokensDetails.fromJson(json['completion_tokens_details']),
    );
  }

  Map<String, dynamic> toJson() => {
    'prompt_tokens': promptTokens,
    'completion_tokens': completionTokens,
    'total_tokens': totalTokens,
    'completion_tokens_details': completionTokensDetails.toJson(),
  };
}

class CompletionTokensDetails {
  final int reasoningTokens;
  final int acceptedPredictionTokens;
  final int rejectedPredictionTokens;

  CompletionTokensDetails({
    required this.reasoningTokens,
    required this.acceptedPredictionTokens,
    required this.rejectedPredictionTokens,
  });

  factory CompletionTokensDetails.fromJson(Map<String, dynamic> json) {
    return CompletionTokensDetails(
      reasoningTokens: json['reasoning_tokens'],
      acceptedPredictionTokens: json['accepted_prediction_tokens'],
      rejectedPredictionTokens: json['rejected_prediction_tokens'],
    );
  }

  Map<String, dynamic> toJson() => {
    'reasoning_tokens': reasoningTokens,
    'accepted_prediction_tokens': acceptedPredictionTokens,
    'rejected_prediction_tokens': rejectedPredictionTokens,
  };
}