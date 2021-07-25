import {CreateEvaluationDto} from '../../src/evaluations/dto/create-evaluation.dto';
import {EvaluationDto} from '../../src/evaluations/dto/evaluation.dto';
import {UpdateEvaluationDto} from '../../src/evaluations/dto/update-evaluation.dto';
import {Evaluation} from '../../src/evaluations/evaluation.model';
import {CREATE_EVALUATION_TAG_DTO} from './evaluation-tags-test.constant';
/* eslint-disable @typescript-eslint/ban-ts-comment */

const DEFAULT_FILE_NAME = 'example-result.json';

// @ts-ignore
export const EVALUATION_1: CreateEvaluationDto = {
  filename: DEFAULT_FILE_NAME,
  evaluationTags: []
};

// @ts-ignore
export const EVALUATION_WITH_TAGS_1: CreateEvaluationDto = {
  filename: DEFAULT_FILE_NAME,
  evaluationTags: [CREATE_EVALUATION_TAG_DTO]
};

// @ts-ignore
export const CREATE_EVALUATION_DTO_WITHOUT_TAGS: CreateEvaluationDto = {
  filename: DEFAULT_FILE_NAME
};

// @ts-ignore
export const CREATE_EVALUATION_DTO_WITHOUT_FILENAME: CreateEvaluationDto = {
  evaluationTags: [CREATE_EVALUATION_TAG_DTO]
};

// @ts-ignore
export const CREATE_EVALUATION_DTO_WITHOUT_DATA: CreateEvaluationDto = {
  filename: DEFAULT_FILE_NAME,
  evaluationTags: [CREATE_EVALUATION_TAG_DTO]
};

// @ts-ignore
export const UPDATE_EVALUATION: UpdateEvaluationDto = {
  data: {
    filename: DEFAULT_FILE_NAME
  },
  filename: 'example-result-new.json'
};

// @ts-ignore
export const UPDATE_EVALUATION_FILENAME_ONLY: UpdateEvaluationDto = {
  filename: 'example-result-new.json'
};

// @ts-ignore
export const UPDATE_EVALUATION_DATA_ONLY: UpdateEvaluationDto = {
  data: {
    filename: DEFAULT_FILE_NAME
  }
};

// @ts-ignore
export const EVALUATION_DTO: EvaluationDto = {
  id: '9999',
  filename: DEFAULT_FILE_NAME,
  evaluationTags: [],
  createdAt: new Date(),
  updatedAt: new Date()
};

// @ts-ignore
export const EVALUATION: Evaluation = {
  id: '9999',
  filename: DEFAULT_FILE_NAME,
  evaluationTags: [],
  createdAt: new Date(),
  updatedAt: new Date()
};
/* eslint-enable @typescript-eslint/ban-ts-comment */
